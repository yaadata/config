local opts = {
  'iamcco/markdown-preview.nvim',
  commit = 'a923f5fc5ba36a3b17e289dc35dc17f66d0548ee',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = 'cd app && npx --yes yarn install',
  keys = {
    {
      '<leader>bov',
      '<cmd>MarkdownPreviewToggle<cr>',
      ft = 'markdown',
      desc = 'Toggle view markdown',
    },
  },
}

return opts
