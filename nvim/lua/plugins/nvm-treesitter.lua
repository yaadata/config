local opts = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'javascript', 'ruby', 'lua', 'rust', 'typescript', 'vimdoc', 'vim', 'go', 'zig', 'kotlin', 'elixir', 'eex', 'heex' },
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ar'] = '@assignment.rhs',
            ['al'] = '@assignment.lhs',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
          goto_next = {
            [']i'] = '@conditional.outer',
            [']a'] = '@parameter.outer',
            [']r'] = '@assignment.rhs',
            [']l'] = '@assignment.lhs',
          },
          goto_previous = {
            ['[i'] = '@conditional.outer',
            ['[a'] = '@parameter.outer',
            ['[r'] = '@assignment.rhs',
            ['[l'] = '@assignment.lhs',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>vta'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>vtA'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}

return opts
