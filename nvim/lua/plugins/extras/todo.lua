local opts = {
  'folke/todo-comments.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim',
    'nvim-telescope/telescope.nvim',
  },
  tag = 'v1.4.0',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      '<leader>sta',
      '<cmd>TodoTelescope cwd=./<CR>',
      '[S]earch [T]odo [A]ll',
    },
    {
      '<leader>qTq',
      '<cmd>TodoQuickFix<CR>',
      'Todo quick fix list',
    },
    {
      '<leader>qTL',
      '<cmd>TodoLocList<CR>',
      'Todo location list',
    },
  },
}

return opts
