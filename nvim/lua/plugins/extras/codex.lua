local opts = {
  'yaadata/codex.nvim',
  version = '0.2.1',
  config = function()
    require('codex').setup {
      cmd = 'codex',
      args = {},
      env = {},
      auto_start = false,
      terminal = {
        provider = 'auto', -- auto | snacks | native | external | none
        window = 'float', -- vsplit | hsplit | float
        vsplit = {
          side = 'right', -- left | right
          size_pct = 40, -- 10-90
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
          clear_input = '<M-BS>',
          nav = {
            left = '<C-h>', -- split windows only; set false to disable
            down = '<C-j>', -- split windows only; set false to disable
            up = '<C-k>', -- split windows only; set false to disable
            right = '<C-l>', -- split windows only; set false to disable
          },
        },
      },
      keymaps = {
        toggle = '<leader>aot',
        open = '<leader>aoo',
        focus = '<leader>aof',
        close = '<leader>aox',
        send = '<leader>aos',
        add = '<leader>aob',
        resume = '<leader>aor',
        model = '<leader>aom',
        status = '<leader>aoi',
        permissions = '<leader>aop',
        compact = '<leader>aoc',
        review = '<leader>aoR',
        diff = '<leader>aod',
      },
      keymaps_force = false, -- keep existing user mappings by default
    }
  end,
}

return opts
