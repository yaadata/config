local opts = {
  'rmagatti/auto-session',
  lazy = false,
  commit = '517a75727d28a4d1ee9c79b56dde239a5408778f',
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wss', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    { '<leader>wsw', '<cmd>SessionSave<CR>', desc = 'Save session' },
    { '<leader>wst', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    { '<leader>wsx', '<cmd>SessionDelete<CR>', desc = 'Delete session' },
  },

  opts = {
    git_use_branch_name = true,
    git_auto_restore_on_branch_change = true,
    show_auto_restore_notif = true,
    auto_delete_empty_sessions = true,
    purge_after_minutes = 43200,
    -- ⚠️ This will only work if Telescope.nvim is installed
    -- The following are already the default values, no need to provide them if these are already the settings you want.
    session_lens = {
      -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
      load_on_setup = true,
      previewer = false,
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { 'i', '<C-D>' },
        alternate_session = { 'i', '<C-S>' },
        copy_session = { 'i', '<C-Y>' },
      },
      -- Can also set some Telescope picker options
      -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
      theme_conf = {
        border = true,
        -- layout_config = {
        --   width = 0.8, -- Can set width and height as percent of window
        --   height = 0.5,
        -- },
      },
    },
  },
}

return opts
