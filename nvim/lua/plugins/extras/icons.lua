local opts = {
  'nvim-tree/nvim-web-devicons',
  enabled = true,
  cmd = {
    'NvimWebDeviconsHiTest',
  },
  config = function()
    require('nvim-web-devicons').setup()
  end,
}

return opts
