local opts = {
  'catppuccin/nvim',
  tag = 'v1.11.0',
  name = 'catppuccin',
  version = '2.0.0',
  priority = 100000,
  lazy = false,
  opts = {
    transparent_background = true, -- disables setting the background color.
    term_colors = true,
    flavour = 'macchiato',
    background = { -- :h background
      light = 'latte',
      dark = 'mocha',
    },
    float = {
      transparent = true, -- if you would like floating windows to *also* be transparent
    },
    integrations = {
      notify = true,
      noice = true,
      fidget = true,
      lsp_trouble = true,
      snacks = {
        enabled = true,
        indent_scope_color = '', -- catppuccin color (eg. `lavender`) Default: overlay2
      },
      overseer = true,
    },
    auto_integrations = true,
    custom_highlights = function(colors)
      return {
        WinSeparator = { fg = colors.surface2 },
        LineNr = { fg = colors.overlay1 },
        CursorLineNr = { fg = colors.flamingo },
        Visual = { bg = colors.overlay1, style = { 'bold' } }, -- Visual mode selection
        VisualNOS = { bg = colors.overlay1, style = { 'bold' } },
      }
    end,
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
return opts
