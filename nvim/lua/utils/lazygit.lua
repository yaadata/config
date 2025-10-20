local M = {}
M.toggle = function()
  local Terminal = require('toggleterm.terminal').Terminal

  local size = 90
  local direction = 'float'

  if not term then
    term = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      on_exit = function()
        term = nil
      end,
    }
    if term then
      term:toggle(size, direction)

      vim.cmd 'set ft=lazygit'
      vim.keymap.set('t', '<c-\\>', function()
        term:toggle(size, direction)
      end, { buffer = true })
    end
  else
    term:toggle(size, direction)
  end
end

return M
