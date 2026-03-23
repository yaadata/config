local opts = {
  'tamton-aquib/staline.nvim',
  commit = 'd337bc9b343df3328921ef4c3f8ff604102d0201',
  config = function()
    vim.opt.laststatus = 2
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
