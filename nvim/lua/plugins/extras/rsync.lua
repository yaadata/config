local opts = {
  'OscarCreator/rsync.nvim',
  build = 'make',
  event = 'VimEnter',
  cmd = { 'RsyncUp', 'RsyncUpFile', 'RsyncDown', 'RsyncDownFile', 'RsyncConfig' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    require('rsync').setup {}
  end,
  keys = {
    {
      '<leader>rda',
      '<cmd>RsyncDown<cr>',
      desc = 'Download all files',
    },
    {
      '<leader>rdf',
      '<cmd>RsyncDownFile<cr>',
      desc = 'Download single file',
    },
    {
      '<leader>rua',
      '<cmd>RsyncUp<cr>',
      desc = 'Upload all files',
    },
    {
      '<leader>rdf',
      '<cmd>RsyncUpFile<cr>',
      desc = 'Upload single file',
    },
    {
      '<leader>rcs',
      '<cmd>RsyncConfig<cr>',
      desc = 'View Rsync Config Setting',
    },
    {
      '<leader>rcp',
      '<cmd>RsyncProjectConfig show<cr>',
      desc = 'View Project Config',
    },
    {
      '<leader>rcr',
      '<cmd>RsyncProjectConfig reload<cr>',
      desc = 'Reload Project Config',
    },
    {
      '<leader>rt',
      '<cmd>RsyncSaveSync<cr>',
      desc = 'Toggle Sync on Save',
    },
  },
}

return opts
