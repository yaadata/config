local opts = {
  'apple/pkl-neovim',
  ft = { 'pkl' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local config = {
      start_command = { 'pkl-lsp' },
    }

    local pkl_cli_path = vim.fn.exepath 'pkl'
    if pkl_cli_path ~= '' then
      config.pkl_cli_path = pkl_cli_path
    end

    vim.g.pkl_neovim = config
  end,
}

return opts
