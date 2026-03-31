local cfg = require('go.lsp').config()

return vim.tbl_deep_extend('force', cfg, {
  cmd = { 'gopls', '--remote=auto' },
  root_dir = function()
    return vim.fn.getcwd()
  end,
  settings = {
    gopls = {
      workspaceFiles = {
        '**/BUILD',
        '**/WORKSPACE',
        '**/*.{bzl,bazel}',
      },
      directoryFilters = {
        '-bazel-bin',
        '-bazel-out',
        '-bazel-testlogs',
        '-bazel-mux',
      },
      gofumpt = true,
      matcher = 'fuzzy',
      symbolMatcher = 'fuzzy',
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        tidy = true,
        test = true,
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
  init_options = {
    buildFlags = { '-tags=integration,unit,endtoendtest,smoke' },
  },
})
