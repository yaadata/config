local M = {}
local task_term

M.toggle = function()
  local Terminal = require('toggleterm.terminal').Terminal

  if not task_term then
    task_term = Terminal:new {
      cmd = 'taskwarrior-tui',
      hidden = true,
      direction = 'float',
      on_open = function(term)
        vim.bo[term.bufnr].filetype = 'taskwarrior'
        for _, key in ipairs { '<c-_>', '<c-\\>' } do
          vim.keymap.set('t', key, function()
            term:toggle(90, 'float')
          end, { buffer = term.bufnr })
        end
        vim.cmd 'startinsert!'
      end,
      on_exit = function()
        task_term = nil
      end,
    }
  end

  task_term:toggle(90, 'float')
end

return M
