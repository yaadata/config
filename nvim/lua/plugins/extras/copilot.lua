local opts = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  commit = '886ee73b6d464b2b3e3e6a7ff55ce87feac423a9',
  keys = {
    { '<leader>co', '<cmd>Copilot enable<CR>', desc = 'Enable Copilot' },
    { '<leader>cx', '<cmd>Copilot disable<CR>', desc = 'Disable Copilot' },
  },
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
        lua = true,
      },
    }
  end,
}

return opts
