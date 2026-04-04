local cfg = require('go.lsp').config()

return vim.tbl_deep_extend('force', cfg, {
  cmd = { 'gopls', '--remote=auto' },
  root_dir = function()
    return vim.fn.getcwd()
  end,
  settings = {
    gopls = {
      gofumpt = true,
      matcher = 'Fuzzy',
      symbolMatcher = 'FastFuzzy',
      codelenses = {
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        ST1000 = false,
        ST1003 = false,
        ST1001 = false,
      },
      hints = {
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      verboseOutput = true,
      buildFlags = { '-tags=integration,unit,endtoendtest,smoke' },
    },
  },
})
