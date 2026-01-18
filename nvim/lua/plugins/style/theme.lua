local opts = {
  'catppuccin/nvim',
  tag = 'v1.11.0',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  opts = {
    transparent_background = true, -- disables setting the background color.
    term_colors = true,
    flavour = 'macchiato',
    background = { -- :h background
      light = 'latte',
      dark = 'mocha',
    },

    integrations = {
      notify = true,
      noice = true,
      fidget = true,
    },
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
