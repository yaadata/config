local opts = {
  'Almo7aya/openingh.nvim',
  commit = '7cc8c897cb6b34d8ed28e99d95baccef609ed251',
  init = function()
    vim.g.openingh_copy_to_register = true
  end,
  config = function()
    vim.api.nvim_set_keymap('n', '<Leader>gfgo', ':OpenInGHRepo <CR>', {
      desc = 'Open Repository',
      silent = true,
      noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<Leader>gfgf', '<cmd>OpenInGHFile <CR>', { silent = true, noremap = true })
    vim.keymap.set('v', '<space>gP', '<cmd>OpenInGHFileLines!<cr>', {
      silent = true,
      noremap = true,
      desc = 'Open file at line position',
    })
    vim.keymap.set('v', '<space>gfgl', '<cmd>OpenInGHFileLines! +<cr>', {
      silent = true,
      noremap = true,
      desc = 'Yank GitHub link to system clipboard',
    })
  end,
}

return opts
