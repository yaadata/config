local opts = {
  'zbirenbaum/copilot.lua',
  cmd = { 'Copilot' },
  config = function()
    require('copilot').setup {}
  end,
}

return opts
