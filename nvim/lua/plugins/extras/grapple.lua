local opts = {
  'cbochs/grapple.nvim',
  commit = 'b41ddfc1c39f87f3d1799b99c2f0f1daa524c5f7',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    { '<leader>ha', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
    { '<leader>ho', ':Telescope grapple tags<enter>', desc = 'Toggle tags menu' },

    { '<leader>h1', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
    { '<leader>h2', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
    { '<leader>h3', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
    { '<leader>h4', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },

    { '<leader>hp', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
    { '<leader>hn', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
  },
  config = function()
    require('grapple').setup {
      scope = 'git_branch', -- also try out "git_branch"
      icons = false, -- setting to "true" requires "nvim-web-devicons"
      status = false,
    }
    require('telescope').load_extension 'grapple'
  end,
}

return opts
