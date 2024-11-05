local opts = {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup {
      cmdline = {
        format = {
          cmdline = { icon = '>' },
          search_down = { icon = '🔍⌄' },
          search_up = { icon = '🔍⌃' },
          filter = { icon = '$' },
          lua = { icon = '☾' },
          help = { icon = '?' },
        },
      },
      format = {
        level = {
          icons = {
            error = '✖',
            warn = '▼',
            info = '●',
          },
        },
      },
      popupmenu = {
        kind_icons = false,
      },
      inc_rename = {
        cmdline = {
          format = {
            IncRename = { icon = '⟳' },
          },
        },
      },
    }
  end,
}

return opts
