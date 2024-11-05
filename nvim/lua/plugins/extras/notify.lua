local opts = {
  'rcarriga/nvim-notify',
  tag = 'v3.14.0',
  config = function()
    local notify = require 'notify'
    vim.notify = notify
    vim.keymap.set('n', '<leader>sN', '<cmd>Telescope notify<CR>', { desc = '[N]otifications' })
  end,
}

return opts
