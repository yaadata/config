local opts = {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  version = '1.9.1', -- optional: only update when a new 1.x version is released
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
  config = function(opts)
    require('barbar').setup(opts)
    local map = vim.api.nvim_set_keymap
    local options = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', options)
    map('n', '<A-.>', '<Cmd>BufferNext<CR>', options)

    -- Re-order to previous/next
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', options)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', options)

    -- Goto buffer in position...
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', options)
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', options)
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', options)
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', options)
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', options)
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', options)
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', options)
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', options)
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', options)
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', options)

    -- Goto pinned/unpinned buffer
    --                 :BufferGotoPinned
    --                 :BufferGotoUnpinned

    -- Close buffer
    map('n', '<leader>bx', '<Cmd>BufferClose<CR>', options)
    map('n', '<leader>bX', '<Cmd>BufferCloseAllButCurrent<CR>', options)
    map('n', '<leader>bax', '<Cmd>BufferCloseAllButCurrent<CR>', options)
    -- Pin/unpin buffer
    map('n', '<leader>bP', '<Cmd>BufferPin<CR>', options)
    -- Wipeout buffer
    --                 :BufferWipeout

    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight

    -- Magic buffer-picking mode
    map('n', '<leader>bp', '<Cmd>BufferPick<CR>', options)

    -- Sort automatically by...
    map('n', '<Space>bob', '<Cmd>BufferOrderByBufferNumber<CR>', options)
    map('n', '<Space>bon', '<Cmd>BufferOrderByName<CR>', options)
    map('n', '<Space>bod', '<Cmd>BufferOrderByDirectory<CR>', options)
    map('n', '<Space>bol', '<Cmd>BufferOrderByLanguage<CR>', options)
    map('n', '<Space>bow', '<Cmd>BufferOrderByWindowNumber<CR>', options)
  end,
}

return opts
