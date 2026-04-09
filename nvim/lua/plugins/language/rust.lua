local opts = {
  'mrcjkb/rustaceanvim',
  tag = 'v9.0.1', -- Recommended
  lazy = false, -- This plugin is already lazy
  dependencies = {
    'neovim/nvim-lspconfig',
  },
}

-- optional plugin - dots for crate graph
-- install with brew install graphviz

return opts
