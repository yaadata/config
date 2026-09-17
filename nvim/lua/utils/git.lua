local M = {}

local function warn(message)
  vim.notify(message, vim.log.levels.WARN)
end

local function run(cwd, args, stdin)
  local command = { 'git', '-C', cwd }
  vim.list_extend(command, args)

  local result = vim.system(command, { text = true, stdin = stdin }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
  return nil, vim.trim(result.stderr)
end

local function commit_url(remote_url, commit)
  local host, path
  local scheme = remote_url:match '^(%w+)://'

  if scheme then
    local address = remote_url:gsub('^%w+://', ''):gsub('^[^/@]+@', '')
    host, path = address:match '^([^/]+)/(.+)$'
  else
    host, path = remote_url:match '^[^@]+@([^:]+):(.+)$'
  end

  if not host or not path then
    return nil
  end

  if scheme == 'ssh' or scheme == 'git' then
    host = host:gsub(':%d+$', '')
  end
  path = path:gsub('/+$', ''):gsub('%.git$', '')

  local normalized_host = host:lower()
  local is_gitlab = normalized_host:find('gitlab', 1, true) ~= nil
  for _, gitlab_host in ipairs(vim.g.gitlab_hosts or {}) do
    is_gitlab = is_gitlab or normalized_host == gitlab_host:lower()
  end
  local route = is_gitlab and '/-/commit/' or '/commit/'
  return ('https://%s/%s%s%s'):format(host, path, route, commit)
end

local function default_remote_ref(root)
  local heads = run(root, {
    'for-each-ref',
    '--format=%(refname) %(symref)',
    'refs/remotes/*/HEAD',
  }) or ''
  local fallback_remote, fallback_ref

  for entry in heads:gmatch '[^\n]+' do
    local head, ref = entry:match '^(%S+)%s+(%S+)$'
    local remote = head and head:match '^refs/remotes/(.+)/HEAD$'
    local prefix = remote and ('refs/remotes/%s/'):format(remote)
    if remote and ref:sub(1, #prefix) == prefix then
      fallback_remote, fallback_ref = fallback_remote or remote, fallback_ref or ref
      local branch = ref:sub(#prefix + 1)
      if run(root, { 'config', '--get', ('branch.%s.remote'):format(branch) }) == remote then
        return remote, ref
      end
    end
  end

  return fallback_remote, fallback_ref
end

local function find_merge_commit(root, default_ref, commit)
  local count = tonumber(run(root, { 'rev-list', '--first-parent', '--merges', '--count', default_ref }))
  if not count then
    return nil
  end

  local first, last, found = 0, count - 1
  while first <= last do
    local index = math.floor((first + last) / 2)
    local candidate = run(root, {
      'rev-list',
      '--first-parent',
      '--merges',
      ('--skip=%d'):format(index),
      '--max-count=1',
      default_ref,
    })
    if candidate and run(root, { 'merge-base', '--is-ancestor', commit, candidate }) then
      found = candidate
      first = index + 1
    else
      last = index - 1
    end
  end

  return found
end

function M.open_line_merge_commit(bufnr, line)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local root = run(vim.fs.dirname(file), { 'rev-parse', '--show-toplevel' })
  if not root then
    return warn 'The current file is not in a Git repository'
  end

  local remote, default_ref = default_remote_ref(root)
  if not remote then
    return warn 'No remote default branch was found; run git remote set-head <remote> --auto'
  end

  line = line or vim.api.nvim_win_get_cursor(0)[1]
  local relative_file = vim.fs.relpath(root, file)
  local separators = { dos = '\r\n', mac = '\r', unix = '\n' }
  local separator = separators[vim.bo[bufnr].fileformat]
  local contents = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), separator)
  if vim.bo[bufnr].endofline then
    contents = contents .. separator
  end
  local blame, blame_error = run(root, {
    'blame',
    '--line-porcelain',
    '--contents',
    '-',
    '-L',
    ('%d,%d'):format(line, line),
    default_ref,
    '--',
    relative_file,
  }, contents)
  if not blame then
    return warn(blame_error ~= '' and blame_error or ('Could not blame the selected line in %s'):format(default_ref))
  end
  local commit = blame and blame:match '^(%x+)'
  if not commit or commit:match '^0+$' then
    return warn(('The selected line is not in %s'):format(default_ref))
  end

  local parent = run(root, { 'rev-parse', '--verify', commit .. '^' })
  local on_first_parent
  if parent then
    local without_commit = tonumber(run(root, { 'rev-list', '--first-parent', '--count', commit .. '..' .. default_ref }))
    local with_commit = tonumber(run(root, { 'rev-list', '--first-parent', '--count', parent .. '..' .. default_ref }))
    on_first_parent = without_commit and with_commit and with_commit == without_commit + 1
  else
    on_first_parent = run(root, { 'rev-list', '--first-parent', '--max-parents=0', '--max-count=1', default_ref }) == commit
  end
  if on_first_parent == nil then
    return warn(('Could not read %s history'):format(default_ref))
  end

  local merge_commit
  if on_first_parent then
    merge_commit = commit
  else
    merge_commit = find_merge_commit(root, default_ref, commit)
  end
  if not merge_commit then
    return warn(('Could not find the merge commit in %s'):format(default_ref))
  end

  local url = commit_url(run(root, { 'remote', 'get-url', remote }) or '', merge_commit)
  if not url then
    return warn(('Could not build a web URL for %s'):format(remote))
  end

  vim.ui.open(url)
end

return M
