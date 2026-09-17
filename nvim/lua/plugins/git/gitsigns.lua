local git = require 'utils.git'

local opts = {
  'lewis6991/gitsigns.nvim',
  commit = '20ad4419564d6e22b189f6738116b38871082332',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk('next', { target = 'all' })
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk('prev', { target = 'all' })
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map('n', '<leader>gds', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>gdr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>gdS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>gdu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>gdR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>gdp', gitsigns.preview_hunk_inline, { desc = 'git [p]review hunk' })
      map('n', '<leader>gdb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'git [b]lame line' })
      map('n', '<leader>gdo', function()
        git.open_line_merge_commit(bufnr)
      end, { desc = 'git [o]pen line merge commit' })
      map('x', '<leader>gdo', function()
        git.open_line_merge_commit(bufnr, vim.fn.line 'v')
      end, { desc = 'git [o]pen selected line merge commit' })
      map('n', '<leader>gdB', gitsigns.blame, { desc = 'Show Blame' })
      map('n', '<leader>gdq', function()
        gitsigns.setqflist 'all'
      end, { desc = 'show all hunks in [Q]uickfix list' })
      -- Toggles
      map('n', '<leader>gdtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>gdtD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    end,
  },
}

return opts
