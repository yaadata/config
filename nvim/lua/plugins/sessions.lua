local opts = {
  'yaadata/auto-session',
  dependencies = { 'ibhagwan/fzf-lua' },
  lazy = false,
  init = function()
    vim.opt.sessionoptions:append 'globals'
  end,
  keys = {
    { '<leader>wss', '<cmd>AutoSession search<CR>', desc = 'Search' },
    { '<leader>wsr', '<cmd>AutoSession restore<CR>', desc = 'Restore' },
    { '<leader>wsw', '<cmd>AutoSession save<CR>', desc = 'Save' },
    { '<leader>wst', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    { '<leader>wsx', '<cmd>AutoSession deletePicker<CR>', desc = 'Delete Picker' },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
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
    session_lens = {
      picker = 'fzf',
      load_on_setup = true,
      previewer = false,
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { 'i', '<C-D>' },
        alternate_session = { 'i', '<C-S>' },
        copy_session = { 'i', '<C-Y>' },
      },
      picker_opts = {
        border = 'rounded',
      },
    },
  },
}

return opts
