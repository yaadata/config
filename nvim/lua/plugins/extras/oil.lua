local opts = {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons', { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    require('oil').setup()
    vim.keymap.set('n', '<leader>fo', '<CMD>Oil<CR>', { desc = 'Open Oil for current directory' })
  end,
}

return opts
