local opts = {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    transparent_background = true,
    flavour = 'macchiato',
    background = { -- :h background
      light = 'latte',
      dark = 'mocha',
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
return opts
