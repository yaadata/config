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
  version = 'v4.1.0',
  config = function()
    require('noice').setup {
      transparent = true,
      cmdline = {
        view = 'cmdline_popup',
        format = {
          cmdline = { icon = '>' },
          search_down = { icon = '🔍⌄' },
          search_up = { icon = '🔍⌃' },
          filter = { icon = '$' },
          lua = { icon = '☾' },
          help = { icon = '?' },
        },
      },
      presets = {
        -- bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
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
