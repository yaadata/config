local opts = {
  'nvim-tree/nvim-web-devicons',
  commit = '737cf6c657898d0c697311d79d361288a1343d50',
  enabled = true,
  cmd = {
    'NvimWebDeviconsHiTest',
  },
  config = function()
    require('nvim-web-devicons').setup()
  end,
}

return opts
