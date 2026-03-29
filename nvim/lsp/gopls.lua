return {
  cmd = { 'gopls', '--remote=auto' },
  settings = {
    completeUnimported = true,
    usePlaceholders = true,
    analyses = {
      unusedparams = true,
      ST1003 = false,
      ST1001 = false,
    },
    hints = {
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
    buildFlags = { 'tags=integration,unit,endtoendtest,smoke' },
  },
  init_options = {
    buildFlags = { '-tags=integration,unit,endtoendtest,smoke' },
  },
}
