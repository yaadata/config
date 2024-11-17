local opts = {
  'rcarriga/nvim-notify',
  tag = 'v3.14.0',
  opts = {
    background_colour = '#000000',
  },
  config = function(_, opts)
    require('notify').setup(opts)
    vim.notify = require 'notify'
    vim.keymap.set('n', '<leader>sN', '<cmd>Telescope notify<CR>', { desc = '[N]otifications' })
  end,
}

return opts
