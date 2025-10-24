local buffname_toggle_num = 0
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
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>ghp', gitsigns.preview_hunk_inline, { desc = 'git [p]review hunk' })
      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'git [b]lame line' })
      map('n', '<leader>gB', gitsigns.blame, { desc = 'Show Blame' })
      map('n', '<leader>gq', function()
        gitsigns.setqflist 'all'
      end, { desc = 'show all hunks in [Q]uickfix list' })
      -- Toggles
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>gtD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    end,
  },
}

return opts
