local opts = {
  'nvim-mini/mini.pairs',
  commit = 'd5a29b6254dad07757832db505ea5aeab9aad43a',
  config = function()
    require('mini.pairs').setup {
      mappings = {
        ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
        ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
      },
    }
  end,
}

return opts
