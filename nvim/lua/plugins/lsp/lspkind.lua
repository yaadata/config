local opts = {
  'onsails/lspkind.nvim',
  commit = 'd79a1c3299ad0ef94e255d045bed9fa26025dab6',
  config = function()
    require('lspkind').setup {
      mode = 'symbol',
      preset = 'default',
      symbol_map = {
        Copilot = '',
      },
    }
  end,
}

return opts
