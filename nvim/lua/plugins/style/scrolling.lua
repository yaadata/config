local opts = {
  'karb94/neoscroll.nvim',
  commit = 'f957373912e88579e26fdaea4735450ff2ef5c9c',
  config = function(_)
    local neoscroll = require 'neoscroll'
    neoscroll.setup {
      mappings = {},
      easing = 'quadratic',
    }
    local keymap = {
      -- Use the "sine" easing function
      ['<C-u>'] = function()
        neoscroll.ctrl_u { duration = 250, easing = 'circular' }
      end,
      ['<C-d>'] = function()
        neoscroll.ctrl_d { duration = 250, easing = 'circular' }
      end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}

return opts
