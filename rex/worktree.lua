rex.action{
  name = "open_worktree_tab",
  title = "Open Worktree Tab",
  category = "Git",
  run = function(ctx)
    local block, block_err = rex.session.describe_block{ block_id = ctx.block_id }
    if not block then error(block_err, 0) end
    local process, process_err = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
    if not process then error(process_err, 0) end
    local foreground = process.foreground
    if not foreground or not foreground.cwd then error("Focus a terminal with a working directory", 0) end
    local status, status_err = rex.call("server.status", {})
    if not status then error(status_err, 0) end
    if block.block.host_id ~= status.host_id or foreground.name == "ssh" then
      error("Open this action from a local terminal", 0)
    end

    -- Actions can be loaded on another machine; resolve files on the terminal host.
    local home = process.home
    if type(home) ~= "string" or home == "" then
      error("The terminal did not report its home directory", 0)
    end
    local worker = home:gsub("/+$", "") .. "/.config/rex/worktree_prompt.lua"
    local args = rex.json.encode{
      cwd = foreground.cwd,
      home = home,
      session_id = ctx.session_id,
    }
    local window, err = rex.session.new_window{
      session_id = ctx.session_id,
      window_label = "New Worktree",
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = {
          shell = "none",
          login = false,
          cwd = foreground.cwd,
          command = { "/usr/bin/env", "rex", "do", worker, "--args", args },
        },
      },
    }
    if not window then error(err, 0) end
    if ctx.client_id then
      rex.client.queue("session.select", { session_id = ctx.session_id, window_id = window.window_id })
    end
  end,
}
