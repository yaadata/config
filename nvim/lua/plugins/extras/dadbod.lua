local opts = {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    'kristijanhusak/vim-dadbod-completion',
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },

  init = function()
    -- Enable Nerd Font icons in DBUI buffers and the connection tree.
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}

return opts
