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
    {
      '<leader>ma',
      function()
        require('grapple').toggle()
      end,
      mode = 'n',
      desc = 'Toggle file tag',
    },
    {
      '<leader>mx',
      function()
        require('grapple').untag()
      end,
      mode = 'n',
      desc = 'Untag a mark',
    },
    {
      '<leader>mX',
      function()
        require('grapple').reset()
      end,
      mode = 'n',
      desc = 'Reset/remove all tags',
    },
    {
      '<leader>mt',
      function()
        require('telescope').extensions.grapple.tags()
      end,
      mode = 'n',
      desc = 'Browse tags',
    },
    {
      '<leader>sm',
      function()
        require('telescope').extensions.grapple.tags()
      end,
      mode = 'n',
      desc = 'Browse tags',
    },
    {
      '<leader>m1',
      function()
        require('grapple').select { index = 1 }
      end,
      mode = 'n',
      desc = 'Select first tag',
    },
    {
      '<leader>m2',
      function()
        require('grapple').select { index = 2 }
      end,
      mode = 'n',
      desc = 'Select second tag',
    },
    {
      '<leader>m3',
      function()
        require('grapple').select { index = 3 }
      end,
      mode = 'n',
      desc = 'Select third tag',
    },
    {
      '<leader>m4',
      function()
        require('grapple').select { index = 4 }
      end,
      mode = 'n',
      desc = 'Select fourth tag',
    },
    {
      '<leader>m5',
      function()
        require('grapple').select { index = 5 }
      end,
      mode = 'n',
      desc = 'Select fifth tag',
    },
    {
      ']m',
      function()
        require('grapple').cycle_tags 'next'
      end,
      mode = 'n',
      desc = 'Go to next tag',
    },
    {
      '[m',
      function()
        require('grapple').cycle_tags 'prev'
      end,
      mode = 'n',
      desc = 'Go to previous tag',
    },
  },
  config = function()
    require('grapple').setup {
      scope = 'git_branch', -- also try out "git_branch"
      icons = true, -- setting to "true" requires "nvim-web-devicons"
      status = true,
    }
    require('telescope').load_extension 'grapple'
  end,
}

return opts
