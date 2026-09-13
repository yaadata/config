local opts = {
  'OscarCreator/rsync.nvim',
  commit = '70be22f23eee7879ebd1bc01de077eca77bdb680',
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
      '<leader>wrda',
      '<cmd>RsyncDown<cr>',
      desc = 'Download all files',
    },
    {
      '<leader>wrdf',
      '<cmd>RsyncDownFile<cr>',
      desc = 'Download single file',
    },
    {
      '<leader>wrua',
      '<cmd>RsyncUp<cr>',
      desc = 'Upload all files',
    },
    {
      '<leader>wrdf',
      '<cmd>RsyncUpFile<cr>',
      desc = 'Upload single file',
    },
    {
      '<leader>wrcs',
      '<cmd>RsyncConfig<cr>',
      desc = 'View Rsync Config Setting',
    },
    {
      '<leader>wrcp',
      '<cmd>RsyncProjectConfig show<cr>',
      desc = 'View Project Config',
    },
    {
      '<leader>wrcr',
      '<cmd>RsyncProjectConfig reload<cr>',
      desc = 'Reload Project Config',
    },
    {
      '<leader>wrt',
      '<cmd>RsyncSaveSync<cr>',
      desc = 'Toggle Sync on Save',
    },
  },
}

return opts
