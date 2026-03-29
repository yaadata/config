local opts = {
  'soulis-1256/eagle.nvim',
  commit = 'dd1a28c4d8626fbe85580b0a9ed8f88d77a26da1',
  config = function()
    require('eagle').setup {
      keyboard_mode = true,
      mouse_mode = false,
    }
    vim.keymap.set('n', '<leader>ld', ':EagleWin<CR>', { noremap = true, silent = true, desc = 'Preview diagnostics' })
  end,
}

return opts
