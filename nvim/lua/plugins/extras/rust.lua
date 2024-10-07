local opts = {
  'mrcjkb/rustaceanvim',
  tag = 'v5.11.0', -- Recommended
  lazy = false, -- This plugin is already lazy
  dependencies = {
    'neovim/nvim-lspconfig',
  },
}

-- optional plugin - dots for crate graph
-- install with brew install graphviz

return opts
