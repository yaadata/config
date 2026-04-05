local opts = {
  'nvim-mini/mini.icons',
  version = 'v0.17.0',
  enabled = true,
  config = function()
    require('mini.icons').setup {
      extension = {
        ['pkl'] = {
          glyph = '󰫽',
          hl = 'MiniIconsCyan',
        },
      },
    }
  end,
}

return opts
