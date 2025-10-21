local M = {}
M.toggle = function()
  local Terminal = require('toggleterm.terminal').Terminal

  local size = 90
  local direction = 'float'

  if not dash_term then
    dash_term = Terminal:new {
      dir = '$HOME',
      cmd = 'gh dash',
      hidden = true,
      on_exit = function()
        dash_term = nil
      end,
    }
    if dash_term then
      dash_term:toggle(size, direction)

      vim.cmd 'set ft=dash'
      vim.keymap.set('t', '<c-_>', function()
        dash_term:toggle(size, direction)
      end, { buffer = true })
      vim.keymap.set('t', '<c-\\>', function()
        dash_term:toggle(size, direction)
      end, { buffer = true })
    end
  else
    dash_term:toggle(size, direction)
    if dash_term:is_open() then
      vim.fn.timer_start(1, function()
        vim.cmd 'startinsert!'
      end)
    end
  end
end

return M
