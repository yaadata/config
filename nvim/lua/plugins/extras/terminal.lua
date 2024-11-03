local opts = {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function(opts)
    require('toggleterm').setup {
      direction = 'float',
      open_mapping = [[<c-\>]],
    }

    vim.keymap.set('n', '<leader>wt', '<cmd>ToggleTerm<CR>', { desc = 'Open Toggle Term' })
  end,
}

return opts
