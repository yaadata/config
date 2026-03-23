local opts = {
  'A7Lavinraj/fyler.nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  commit = '73876e66efafd1f4b76a117f8923484936eb934e',
  opts = {
    views = {
      finder = {
        close_on_select = false,
        git_status = {
          enabled = true,
          symbols = {
            Added = '',
            Modified = '',
            Deleted = '󰆴',
            Conflict = '',
            Ignored = '',
            Renamed = '󰆑',
          },
        },
        icon_provider = 'nvim_web_devicons',
        icon = {
          directory_empty = '',
          directory_expanded = '',
        },
        mappings = {
          ['-'] = 'GotoParent',
          ['_'] = 'SelectSplit',
        },
        win = {
          kinds = {
            float = {
              height = '80%',
              left = '70%',
              width = '30%',
            },
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>ft',
      function()
        require('fyler').toggle {
          kind = 'float',
        }
      end,
      desc = 'Open File Tree',
    },
    {
      '<leader>fg',
      function()
        require('fyler').toggle {
          kind = 'float',
          dir = vim.fs.root(0, '.git'),
        }
      end,
      desc = 'Open Nearest Git File Tree',
    },
  },
}

return opts
