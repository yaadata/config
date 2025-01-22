local opts = {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  opts = {
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
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
return opts
