local opts = {
  'A7Lavinraj/fyler.nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  version = 'v1.1.0',
  opts = {
    close_on_select = false,
    git_status = {
      enabled = false,
    },
    icon_provider = 'nvim_web_devicons',
    mappings = {
      ['-'] = 'GotoParent',
      ['_'] = 'SelectSplit',
    },
  },
  keys = {
    {
      '<leader>ft',
      function()
        require('fyler').toggle {
          kind = 'split_left_most',
        }
      end,
      desc = 'Open File Tree',
    },
    {
      '<leader>fg',
      function()
        require('fyler').toggle {
          dir = vim.fs.root(0, '.git'),
          kind = 'split_left_most',
        }
      end,
      desc = 'Open Nearest Git File Tree',
    },
  },
}

return opts
