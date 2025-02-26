local opts = {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  version = 'v1.1.0',
  config = function()
    require('nvim-tree').setup {
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      log = {
        enable = true,
        truncate = true,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          diagnostics = true,
          git = false,
          profile = false,
          watcher = true,
        },
      },
      diagnostics = {
        enable = false,
        show_on_dirs = false,
        show_on_open_dirs = false,
        debounce_delay = 500,

        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = 'H',
          info = 'I',
          warning = 'W',
          error = 'E',
        },
      },
      git = {
        enable = true,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
        remove_file = {
          close_window = true,
        },
        change_dir = {
          enable = true,
          global = true,
          restrict_above_cwd = false,
        },
      },
      renderer = {
        root_folder_label = true,
        highlight_git = true,
        highlight_opened_files = 'none',
        indent_markers = {
          enable = true,
          icons = {
            corner = '└',
            edge = '│',
            none = '',
          },
        },

        icons = {
          git_placement = 'after',
          modified_placement = 'after',
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },

          glyphs = {
            default = '',
            symlink = '',
            folder = {
              default = '/',
              empty = '/',
              empty_open = '/',
              open = '/',
              symlink = '/',
              symlink_open = '/',
            },
            git = {
              unstaged = '[U]',
              staged = '[S]',
              unmerged = '[ ]',
              renamed = '[R]',
              untracked = '[?]',
              deleted = '[D]',
              ignored = '[I]',
            },
          },
        },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>fT', '<CMD>NvimTreeToggle<CR>', { desc = 'Open File Tree' })
  end,
}

return opts
