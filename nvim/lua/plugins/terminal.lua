local opts = {
  'akinsho/toggleterm.nvim',
  commit = '9a88eae817ef395952e08650b3283726786fb5fb',
  config = function(opts)
    require('toggleterm').setup {
      direction = 'float',
      open_mapping = [[<c-\>]],
    }

    vim.keymap.set('n', '<leader>wt', '<cmd>ToggleTerm<CR>', { desc = 'Open Toggle Term' })
  end,
}

return opts
