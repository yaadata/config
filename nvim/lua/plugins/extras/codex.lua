local opts = {
  'yaadata/codex.nvim',
  version = '0.4.1',
  cmd = {
    'Codex',
    'CodexFocus',
    'CodexClose',
    'CodexClearInput',
    'CodexSend',
    'CodexAddBuffer',
    'CodexMentionFile',
    'CodexMentionDirectory',
    'CodexResume',
    'CodexModel',
    'CodexStatus',
    'CodexPermissions',
    'CodexCompact',
    'CodexReview',
    'CodexDiff',
  },
  keys = {
    {
      '<leader>aot',
      function()
        require('codex').toggle()
      end,
      desc = 'Codex: Toggle terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoo',
      function()
        require('codex').open(true)
      end,
      desc = 'Codex: Open and focus',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aof',
      function()
        require('codex').focus()
      end,
      desc = 'Codex: Focus terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aox',
      function()
        require('codex').close()
      end,
      desc = 'Codex: Close session',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aos',
      function()
        require('codex').send_buffer()
      end,
      desc = 'Codex: Add current buffer',
      mode = 'n',
    },
    {
      '<leader>aos',
      function()
        require('codex').send_selection()
      end,
      desc = 'Codex: Send selection',
      mode = 'x',
    },
    {
      '<leader>aom',
      function()
        require('codex').mention_file()
        require('codex').focus()
      end,
      desc = 'Codex: Mention current file',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoM',
      function()
        require('codex').mention_directory()
      end,
      desc = 'Codex: Mention current directory',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoi',
      function()
        require('codex').show_status()
      end,
      desc = 'Codex: Show status',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aor',
      function()
        require('codex').resume()
      end,
      desc = 'Codex: Resume session',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aop',
      function()
        require('codex').show_permissions()
      end,
      desc = 'Codex: Permissions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoc',
      function()
        require('codex').compact()
      end,
      desc = 'Codex: Compact context',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoR',
      function()
        require('codex').review()
      end,
      desc = 'Codex: Review changes',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aod',
      function()
        require('codex').show_diff()
      end,
      desc = 'Codex: Show diff',
      mode = { 'n', 'v' },
    },
  },
  opts = {
    launch = {
      cmd = 'codex',
      args = {},
      env = {},
      auto_start = false,
      cwd = nil,
    },
    log = {
      level = 'debug',
      verbose = true,
    },
    terminal = {
      provider = 'auto', -- auto | snacks | native | external | none
      window = 'vsplit', -- vsplit | hsplit | float
      vsplit = {
        side = 'right', -- left | right
        size_pct = 20, -- 10-90
      },
      hsplit = {
        side = 'bottom', -- top | bottom
        size_pct = 30, -- 10-90
      },
      float = {
        width_pct = 90, -- 10-100
        height_pct = 90, -- 10-100
        border = 'rounded',
        title = ' Codex ',
        title_pos = 'center', -- left | center | right
      },
      auto_close = false,
      startup = {
        timeout_ms = 2000, -- max time to wait for startup readiness before dropping queued sends
        retry_interval_ms = 50, -- retry interval while waiting for startup readiness
        grace_ms = 400, -- minimum delay after terminal open before first send
      },
      keymaps = {
        toggle = '<C-c>', -- terminal-mode toggle for Codex window
        close = '<C-x>', -- set a string (e.g. "<C-x>") to close Codex session
        nav = {
          left = '<C-h>', -- split windows only; set false to disable
          down = '<C-j>', -- split windows only; set false to disable
          up = '<C-k>', -- split windows only; set false to disable
          right = '<C-l>', -- split windows only; set false to disable
        },
      },
      provider_opts = {
        snacks = {
          win = {
            title = ' Openai Codex ',
            title_pos = 'center',
            wo = {
              winbar = ' Openai Codex ',
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require('codex').setup(opts)
  end,
}

return opts
