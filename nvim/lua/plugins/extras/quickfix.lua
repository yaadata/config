local opts = {
  'kevinhwang91/nvim-bqf',
  build = ':TSInstall',
  config = function()
    require('bqf').setup {
      preview = {
        winblend = 0,
      },
    }
  end,
}

return opts
