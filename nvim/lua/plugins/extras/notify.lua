local opts = {
  'rcarriga/nvim-notify',
  tag = 'v3.15.0',
  opts = {
    timeout = 400,
    background_colour = '#000000',
    render = 'compact',
    stages = 'fade_in_slide_out',
    top_down = false,
  },
  config = function(_, opts)
    require('notify').setup(opts)
    vim.notify = require 'notify'
    vim.keymap.set('n', '<leader>ns', '<cmd>Telescope notify<CR>', { desc = '[S]earch' })
    vim.keymap.set('n', '<leader>nd', function()
      require('notify').dismiss()
    end, { desc = '[d]ismiss all notification' })
  end,
}

return opts
