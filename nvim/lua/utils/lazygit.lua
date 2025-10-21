local M = {}
M.toggle = function()
  local Terminal = require('toggleterm.terminal').Terminal

  local size = 90
  local direction = 'float'

  if not lg_term then
    lg_term = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      on_exit = function()
        lg_term = nil
      end,
    }
    if lg_term then
      lg_term:toggle(size, direction)

      vim.cmd 'set ft=lazygit'
      vim.keymap.set('t', '<c-_>', function()
        lg_term:toggle(size, direction)
      end, { buffer = true })
      vim.keymap.set('t', '<c-\\>', function()
        lg_term:toggle(size, direction)
      end, { buffer = true })
    end
  else
    lg_term:toggle(size, direction)
    if lg_term:is_open() then
      vim.fn.timer_start(1, function()
        vim.cmd 'startinsert!'
      end)
    end
  end
end

return M
