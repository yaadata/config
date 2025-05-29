local opts = {
  'coffebar/transfer.nvim',
  lazy = true,
  cmd = { 'TransferInit', 'DiffRemote', 'TransferUpload', 'TransferDownload', 'TransferDirDiff', 'TransferRepeat' },
  opts = {},
  keys = {
    {
      '<leader>rd',
      '<cmd>TransferDownload<cr>',
      desc = 'Download from remote server (scp)',
    },
    {
      '<leader>rf',
      '<cmd>DiffRemote<cr>',
      desc = 'Diff file with remote server (scp)',
    },
    {
      '<leader>ri',
      '<cmd>TransferInit<cr>',
      desc = 'Init/Edit Deployment config',
    },
    {
      '<leader>rtr',
      '<cmd>TransferRepeat<cr>',
      desc = 'Repeat transfer command',
    },
    {
      '<leader>rtu',
      '<cmd>TransferUpload<cr>',
      desc = 'Upload to remote server (scp)',
    },
  },
}

return opts
