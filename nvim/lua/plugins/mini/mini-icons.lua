local opts = {
  'nvim-mini/mini.icons',
  commit = 'efc85e42262cd0c9e1fdbf806c25cb0be6de115c',
  config = function()
    require('mini.icons').setup {}
  end,
}

return opts
