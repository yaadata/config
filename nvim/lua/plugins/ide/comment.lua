local opts = {
  'JoosepAlviste/nvim-ts-context-commentstring',
  commit = '44fd461b879d80a21d5041f312f070f22551c0bc',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          pre_hook = function()
            return vim.bo.commentstring
          end,
        }
      end,
    },
  },
  config = function()
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }
  end,
}

return opts
