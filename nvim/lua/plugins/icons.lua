local opts = {
  'nvim-tree/nvim-web-devicons',
  commit = '737cf6c657898d0c697311d79d361288a1343d50',
  enabled = true,
  cmd = {
    'NvimWebDeviconsHiTest',
  },
  config = function()
    require('nvim-web-devicons').setup {
      override = {
        pkl = {
          icon = '󰫽', -- pick a Nerd Font glyph
          color = '#00FFFF',
          cterm_color = '66',
          name = 'pkl',
        },
      },
      default = true,
    }
  end,
}

return opts
