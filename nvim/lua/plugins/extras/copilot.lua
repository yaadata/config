local opts = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        golang = true,
        rust = true,
        python = true,
        javascript = true,
        typescript = true,
        c = true,
        cpp = true,
      },
    }
    vim.cmd 'Copilot disable'
  end,
}

return opts
