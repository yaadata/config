local opts = {
  'stevearc/dressing.nvim',
  dependencies = { 'ibhagwan/fzf-lua' },
  opts = {
    select = {
      backend = { 'fzf_lua', 'builtin' },
    },
  },
}

return opts
