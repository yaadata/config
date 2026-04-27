local opts = {
  'yaadata/auto-session',
  lazy = false,
  init = function()
    vim.opt.sessionoptions:append 'globals'
  end,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wss', '<cmd>AutoSession search<CR>', desc = 'Search' },
    { '<leader>wsr', '<cmd>AutoSession restore<CR>', desc = 'Restore' },
    { '<leader>wsw', '<cmd>AutoSession save<CR>', desc = 'Save' },
    { '<leader>wst', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    { '<leader>wsx', '<cmd>AutoSession deletePicker<CR>', desc = 'Delete Picker' },
  },

  opts = {
    git_use_branch_name = true,
    git_auto_restore_on_branch_change = false,
    lsp_stop_on_restore = true,
    show_auto_restore_notif = true,
    auto_delete_empty_sessions = true,
    purge_after_minutes = 43200,
    bypass_save_filetypes = { 'alpha' }, -- don't save alpha as a session
    pre_save_cmds = {
      function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
      end,
    },
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
