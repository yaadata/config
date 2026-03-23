local opts = {
  'nvim-treesitter/nvim-treesitter',
  version = 'v0.10.0',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'javascript',
        'ruby',
        'lua',
        'rust',
        'typescript',
        'vimdoc',
        'vim',
        'go',
        'python',
        'starlark',
        'zig',
        'kotlin',
        'elixir',
        'eex',
        'heex',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true, disable = { 'python' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<leader>vti',
          node_incremental = '<leader>vtn',
          scope_incremental = '<leader>vts',
          node_decremental = '<leader>vtd',
        },
      },
    }
  end,
}

return opts
