local opts = {
  'yaadata/codex.nvim',
  version = '0.1.0',
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
      },
      keymaps = {
        toggle = '<leader>aot',
        open = '<leader>aoo',
        focus = '<leader>aof',
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
