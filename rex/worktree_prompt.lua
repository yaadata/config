local cwd, home, session_id = rex.args.cwd, rex.args.home, rex.args.session_id

local function run(argv, missing_ok)
  local result, err = rex.exec(argv, { cwd = cwd, env = { GIT_TERMINAL_PROMPT = "0" } })
  if not result then error(err, 0) end
  if result.ok then return result.stdout end
  if missing_ok and result.code == 1 then return nil end
  error(result.stderr ~= "" and result.stderr or argv[1] .. " failed", 0)
end

local function git(argv, missing_ok)
  table.insert(argv, 1, "git")
  return run(argv, missing_ok)
end

local function pr_branch(repo, number)
  local base, owner, name = repo:gsub("%.git$", ""):match("^(https?://.-)/([^/]+)/([^/]+)$")
  if not base then return nil, "Unsupported PR repository URL" end

  local failures = {}
  local function failed(command, result, err)
    local message = err
    if result then
      message = result.stderr ~= "" and result.stderr or "exit status " .. tostring(result.code)
    end
    message = tostring(message or "command failed"):match("[^\r\n]+") or "command failed"
    failures[#failures + 1] = command .. ": " .. message:sub(1, 300)
  end

  local url
  if base:lower():match("^https?://github%.com$") then
    local result, err = rex.exec({ "gh", "pr", "view", repo .. "/pull/" .. number,
      "--json", "headRefName", "--jq", ".headRefName" },
      { cwd = cwd, env = {
        GH_PROMPT_DISABLED = "1",
        -- Rex's non-login terminals may not include Homebrew in PATH.
        PATH = (os.getenv("PATH") or "/usr/bin:/bin") .. ":/opt/homebrew/bin:/usr/local/bin",
      } })
    if result and result.ok then
      local branch = result.stdout:gsub("%s+$", "")
      if branch ~= "" then return branch end
      failed("gh", nil, "empty branch name")
    else
      failed("gh", result, err)
    end
    url = "https://api.github.com/repos/" .. owner .. "/" .. name .. "/pulls/" .. number
  else
    url = base .. "/api/v1/repos/" .. owner .. "/" .. name .. "/pulls/" .. number
  end

  local result, err = rex.exec({ "curl", "-fsSL", url }, { cwd = cwd })
  if not result or not result.ok then
    failed("curl", result, err)
  else
    local ok, data, decode_err = pcall(rex.json.decode, result.stdout)
    if not ok or data == nil then
      failed("PR response JSON", nil, (ok and decode_err or data) or "invalid JSON")
    elseif type(data) == "table" and type(data.head) == "table"
        and type(data.head.ref) == "string" and data.head.ref ~= "" then
      return data.head.ref
    else
      failed("PR response", nil, "missing or empty head.ref")
    end
  end
  return nil, table.concat(failures, "; ")
end

local function prompt(label)
  io.write(label)
  io.flush()
  return io.read("*l")
end

local function worktrees()
  local entries = {}
  local list = git({ "worktree", "list", "--porcelain", "-z" })
  for record in list:gmatch("(.-)%z%z") do
    entries[#entries + 1] = {
      path = record:match("^worktree ([^%z]+)"),
      branch = record:match("%zbranch refs/heads/([^%z]+)"),
    }
  end
  return entries
end

local function target_path(root, name)
  home = home:gsub("/+$", "")
  if home == "" then home = "/" end
  local prefix = home == "/" and "/" or home .. "/"
  local relative = ""
  if root ~= home then
    if root:sub(1, #prefix) ~= prefix then
      error("The repository must be under " .. home, 0)
    end
    relative = root:sub(#prefix + 1)
  end
  local base = (home == "/" and "" or home) .. "/.rex-trees"
  if relative ~= "" then base = base .. "/" .. relative end
  return base .. "/" .. name
end

local function remote_branches(branch)
  local matches = {}
  for remote in git({ "remote" }):gmatch("[^\r\n]+") do
    local ref = "refs/remotes/" .. remote .. "/" .. branch
    if git({ "show-ref", "--verify", "--quiet", ref }, true) then
      matches[#matches + 1] = { remote = remote, ref = ref }
    end
  end
  return matches
end

local function select_remote(matches)
  if #matches == 1 then return matches[1] end
  for i, item in ipairs(matches) do print(i .. ") " .. item.remote) end
  local answer = prompt("Choose a remote (Enter to cancel): ")
  if not answer or answer == "" then return nil end
  local item = matches[tonumber(answer)]
  if not item then error("Invalid remote selection", 0) end
  return item
end

local function open_tab(path, name)
  local prompt_block = os.getenv("REX_BLOCK")
  local prompt, err = rex.session.describe_block{ block_id = prompt_block }
  if not prompt then error(err, 0) end
  local renamed, rename_err = rex.session.set_window_label{
    session_id = session_id,
    window_id = prompt.block.window_id,
    label = #name <= 128 and name or "",
  }
  if not renamed then error(rename_err, 0) end
  local result, split_err = rex.session.new_split{
    session_id = session_id,
    anchor_id = prompt_block,
    direction = "horizontal",
    side = "after",
    focus = true,
    layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      options = { cwd = path },
    },
  }
  if not result then
    error("Worktree is at " .. path .. ", but Rex could not open its shell: " .. tostring(split_err), 0)
  end
end

local function open_worktree(input)
  local entries = worktrees()
  local root = entries[1].path
  local repo, number = input:match("^(https?://.-)/pull/(%d+)")
  if not repo then repo, number = input:match("^(https?://.-)/pulls/(%d+)") end

  if input:match("^https?://") then
    if not repo then error("Enter a GitHub or Forgejo pull-request URL", 0) end
    local path = target_path(root, "pr-" .. number)
    print("Fetching pull request...")
    io.flush()
    local ref = "refs/rex-worktree/reviews/" .. run({ "uuidgen" }):gsub("%s+$", "")
    git({ "fetch", "--no-write-fetch-head", "--no-tags", "--no-recurse-submodules",
      "--refmap=", repo:gsub("%.git$", "") .. ".git",
      "refs/pull/" .. number .. "/head:" .. ref })
    local commit = git({ "rev-parse", "--verify", ref .. "^{commit}" }):gsub("\n$", "")
    local ok, failure = pcall(function()
      run({ "mkdir", "-p", path:match("^(.*)/[^/]+$") })
      git({ "worktree", "add", "--detach", path, commit })
    end)
    local cleaned, cleanup_err = pcall(git, { "update-ref", "-d", ref, commit })
    if not cleaned then print("Could not remove temporary ref " .. ref .. ": " .. tostring(cleanup_err)) end
    if not ok then error(failure, 0) end
    local branch, lookup_err = pr_branch(repo, number)
    if not branch then
      if lookup_err then print("PR branch lookup failed: " .. lookup_err) end
      branch = prompt("Unable to determine the PR branch; enter it for the window name (Enter for unknown): ")
      if not branch or branch == "" then branch = "unknown" end
    end
    open_tab(path, "PR#" .. number .. " (" .. branch .. ")")
    return
  end

  local branch = git({ "check-ref-format", "--branch", input }):gsub("\n$", "")
  for _, entry in ipairs(entries) do
    if entry.branch == branch then open_tab(entry.path, "Tree (" .. branch .. ")"); return end
  end

  local path = target_path(root, branch)
  local local_branch = git({ "show-ref", "--verify", "--quiet", "refs/heads/" .. branch }, true)
  local tracking
  if not local_branch then
    local matches = remote_branches(branch)
    if #matches == 0 then
      local answer = prompt("No matching branch. Enter: create from HEAD; f: fetch remotes; q: cancel: ")
      if not answer or answer:lower() == "q" then return end
      if answer:lower() == "f" then
        print("Fetching remotes...")
        io.flush()
        git({ "fetch", "--all" })
        matches = remote_branches(branch)
        if #matches == 0 then error("No remote has branch " .. branch, 0) end
      elseif answer ~= "" then
        error("Choose Enter, f, or q", 0)
      end
    end
    if #matches > 0 then
      tracking = select_remote(matches)
      if not tracking then return end
    end
  end

  run({ "mkdir", "-p", path:match("^(.*)/[^/]+$") })
  if local_branch then
    git({ "worktree", "add", path, branch })
  elseif tracking then
    git({ "worktree", "add", "--track", "-b", branch, path, tracking.ref })
  else
    git({ "worktree", "add", "-b", branch, path, "HEAD" })
  end
  open_tab(path, "Tree (" .. branch .. ")")
end

while true do
  local input = prompt("Branch or pull-request URL (Enter to cancel): ")
  if not input or input == "" then return end
  local ok, err = pcall(open_worktree, input)
  if ok then return end
  print("Error: " .. tostring(err))
end
