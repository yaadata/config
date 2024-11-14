local opts = {
  'Almo7aya/openingh.nvim',

  init = function()
    vim.g.openingh_copy_to_register = true
  end,
  config = function()
    vim.api.nvim_set_keymap('n', '<Leader>gor', ':OpenInGHRepo <CR>', {
      desc = 'Open Repository',
      silent = true,
      noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<Leader>gof', '<cmd>OpenInGHFile <CR>', { silent = true, noremap = true })
    vim.keymap.set('v', '<space>gyf', '<cmd>OpenInGHFileLines! +<cr>', {
      silent = true,
      noremap = true,
      desc = 'Yank GitHub link to system clipboard',
    })
    vim.keymap.set('v', '<space>gof', '<cmd>OpenInGHFileLines!<cr>', {
      silent = true,
      noremap = true,
      desc = 'Open file at line position',
    })
  end,
}

return opts
