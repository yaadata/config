local opts = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  commit = '886ee73b6d464b2b3e3e6a7ff55ce87feac423a9',
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
