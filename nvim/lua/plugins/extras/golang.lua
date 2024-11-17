local opts = {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  config = function()
    require('go').setup {
      lsp_inlay_hints = {
        enable = false,
      },
      lsp_cfg = {
        settings = {
          gopls = {
            usePlaceholders = false,
            analyses = {
              ST1003 = false,
            },
            buildFlags = { '-tags', 'integration,unit,endtoendtest,smoke' },
          },
        },
      },
      lsp_keymaps = false,
      run_in_floaterm = true,
      floaterm = { -- position
        posititon = 'bottom', -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
        height = 0.25, -- height of float window if not auto
        title_colors = 'monokai', -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
        -- can also set to a list of colors to define colors to choose from
        -- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
      },
    }
  end,
}
return opts
