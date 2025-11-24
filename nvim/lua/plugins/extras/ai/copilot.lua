local opts = {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
    {
      'folke/snacks.nvim',
      tag = 'v2.30.0',
    },
  },
  config = function()
    require('copilot').setup {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        go = true,
        javascript = true,
        typescript = true,
        rust = true,
        python = true,
        jsx = true,
        tsx = true,
        terraform = true,
        lua = true,
        ['*'] = false,
      },
    }

    Snacks.toggle({
      name = 'Github Copilot',
      get = function()
        if not vim.g.copilot_enabled then -- HACK: since it's disabled by default the below will throw error
          return false
        end
        return not require('copilot.client').is_disabled()
      end,
      set = function(state)
        if state then
          require('copilot').setup() -- setting up for the very first time
          require('copilot.command').enable()
          vim.g.copilot_enabled = true
        else
          require('copilot.command').disable()
          vim.g.copilot_enabled = false
        end
      end,
    }):map '<leader>ag'
  end,
}

return opts
