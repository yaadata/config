local parsers = {
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
  'pkl',
  'yaml',
  'helm',
  'make',
}

local opts = {
  'nvim-treesitter/nvim-treesitter',
  commit = '4916d6592ede8c07973490d9322f187e07dfefac',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local nvim_treesitter = require 'nvim-treesitter'

    -- `pkl` is provided by apple/pkl-neovim, not nvim-treesitter itself.
    pcall(function()
      require('pkl-neovim').init()
    end)

    nvim_treesitter.setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }
    nvim_treesitter.install(parsers)

    local group = vim.api.nvim_create_augroup('nvim-treesitter-features', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = '*',
      callback = function(args)
        if vim.bo[args.buf].buftype ~= '' then
          return
        end

        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then
          return
        end

        if vim.bo[args.buf].filetype == 'python' then
          return
        end

        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}

return opts
