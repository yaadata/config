local opts = {
  'saghen/blink.compat',
  lazy = true,
  version = 'v1.1.1',
  opts = {},
  config = function()
    -- monkeypatch cmp.ConfirmBehavior for Avante
    require('cmp').ConfirmBehavior = {
      Insert = 'insert',
      Replace = 'replace',
    }
  end,
}

return opts
