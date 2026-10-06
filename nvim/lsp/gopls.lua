return {
  cmd = { 'gopls', '--remote=auto' },
  filetypes = { 'go', 'gomod', 'gosum', 'gowork', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
  flags = { debounce_text_changes = 500 },
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      vim.fs.root(path, 'go.work')
        or vim.fs.root(path, 'go.mod')
        or vim.fs.root(path, { 'MODULE.bazel', 'WORKSPACE.bazel', 'WORKSPACE' })
        or vim.fs.root(path, '.git')
        or vim.fs.dirname(path)
    )
  end,
  settings = {
    gopls = {
      gofumpt = true,
      matcher = 'fuzzy',
      symbolMatcher = 'fuzzy',
      staticcheck = true,
      diagnosticsTrigger = 'Save',
      diagnosticsDelay = '250ms',
      semanticTokens = false,
      vulncheck = 'Imports',
      directoryFilters = { '-**/node_modules', '-bazel-bin', '-bazel-out', '-bazel-testlogs', '-bazel-mux' },
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
    },
  },
}
