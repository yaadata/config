local opts = {
  'j-hui/fidget.nvim',
  tag = 'v1.6.1', -- Make sure to update this to something recent!
  config = function()
    require('fidget').setup {
      notification = { -- NOTE: you're missing this outer table
        window = {
          winblend = 0, -- NOTE: it's winblend, not blend
        },
      },
    }

    vim.keymap.set('n', '<leader>sF', require('telescope').extensions.fidget.fidget, { desc = 'Search [F]idget [N]otifications' })
  end,
}

return opts
