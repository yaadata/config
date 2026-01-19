local opts = {
  'stevearc/oil.nvim',
  opts = {},
  commit = 'f55b25e493a7df76371cfadd0ded5004cb9cd48a',
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons', { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    local preview_enabled = false
    local oil = require 'oil'
    oil.setup {
      float = {
        max_width = 0.85,
        max_height = 0.75,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
      silence_scp_warning = true,
      keymaps = {
        ['gp'] = {
          desc = 'Toggle Preview',
          callback = function()
            if not preview_enabled then
              require('oil').open_preview {
                vertical = true,
                split = 'botright',
              }
              preview_enabled = true
            else
              vim.cmd.pclose()
              preview_enabled = false
            end
          end,
        },
        ['gh'] = {
          desc = 'Toggle [H]idden',
          callback = function()
            require('oil').toggle_hidden()
          end,
        },
      },
    }
    vim.keymap.set('n', '<leader>fo', function()
      oil.toggle_float()
    end, { desc = 'Open Oil for current directory' })
  end,
}

return opts
