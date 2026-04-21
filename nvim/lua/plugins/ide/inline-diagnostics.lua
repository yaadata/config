local opts = {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  commit = '576351d53c1f6bda70252c3aaa710b01472024aa',
  priority = 1000, -- needs to be loaded in first
  config = function()
    local tid = require 'tiny-inline-diagnostic'

    tid.setup {
      preset = 'minimal',
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>ltd', function()
      tid.toggle()
    end, { desc = 'toggle inline diagnostics' })
  end,
}

return opts
