local M = {}
M.toggle = function()
  local Terminal = require('toggleterm.terminal').Terminal

  local size = 90
  local direction = 'float'

  if not k9s_term then
    k9s_term = Terminal:new {
      dir = '$HOME',
      cmd = 'k9s',
      hidden = true,
      on_exit = function()
        k9s_term = nil
      end,
    }
    if k9s_term then
      k9s_term:toggle(size, direction)

      vim.cmd 'set ft=k9s'
      vim.keymap.set('t', '<c-_>', function()
        k9s_term:toggle(size, direction)
      end, { buffer = true })
      vim.keymap.set('t', '<c-\\>', function()
        k9s_term:toggle(size, direction)
      end, { buffer = true })
    end
  else
    k9s_term:toggle(size, direction)
    if k9s_term:is_open() then
      vim.fn.timer_start(1, function()
        vim.cmd 'startinsert!'
      end)
    end
  end
end

return M
