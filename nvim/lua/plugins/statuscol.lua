local opts = {
  'tamton-aquib/staline.nvim',
  config = function()
    vim.opt.showtabline = 2
    vim.opt.termguicolors = true
    require('stabline').setup {
      style = 'slant',
      bg = '#986fec',
      fg = 'black',
      stab_right = '',
    }
  end,
}

return opts
