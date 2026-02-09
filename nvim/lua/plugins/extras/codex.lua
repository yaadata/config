local opts = {
  'yaadata/codex.nvim',
  commit = 'c9e8b56690a7d1d4e67fd6bc78ac5893b4b5102a',
  config = function()
    require('codex').setup {
      cmd = 'codex',
      args = {},
      env = {},
      auto_start = false,
      terminal = {
        provider = 'snacks', -- auto | snacks | native | external | none
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
      },
      keymaps = {
        toggle = '<leader>aot',
        open = '<leader>aoo',
        focus = '<leader>aof',
        send = '<leader>aos',
        add = '<leader>aoa',
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
