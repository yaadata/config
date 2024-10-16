local opts = {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup {}
    vim.keymap.set('n', '<space>ft', ':Telescope file_browser<CR>', { desc = 'Toggle / Browser Project Directory' })
    -- open file_browser with the path of the current buffer
    vim.keymap.set('n', '<space>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Browser current buffer' })
  end,
}

return opts
