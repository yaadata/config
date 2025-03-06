local opts = { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  version = 'v2.1.0',
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>cc'] = { name = '[C]opilot', _ = 'which_key_ignore' },
      ['<leader>l'] = { name = '[l]sp', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]iagnostics', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>n'] = { name = '[N]otification', _ = 'which_key_ignore' },
      ['<leader>sm'] = { name = '[M]ulti-cursor', _ = 'which_key_ignore' },
      ['<leader>sq'] = { name = '[Q]uickfix', _ = 'which_key_ignore' },
      ['<leader>st'] = { name = '[T]odo', _ = 'which_key_ignore' },
      ['<leader>sc'] = { name = '[C]ommands', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      ['<leader>ws'] = { name = '[s]ession', _ = 'which_key_ignore' },
      ['<leader>wm'] = { name = '[m]anagement', _ = 'which_key_ignore' },
      ['<leader>wms'] = { name = '[s]plit', _ = 'which_key_ignore' },
      ['<leader>q'] = { name = 'quickfix / trouble / location list', _ = 'which_key_ignore' },
      ['<leader>qt'] = { name = 'trouble', _ = 'which_key_ignore' },
      ['<leader>ql'] = { name = 'location list', _ = 'which_key_ignore' },
      ['<leader>qT'] = { name = 'Todo', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Grapple', _ = 'which_key_ignore' },
      ['<leader>m'] = { name = '[m]ini.nvim', _ = 'which_key_ignore' },
      ['<leader>ms'] = { name = '[M]ini [S]urround', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = 'Git', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[T]est', _ = 'which_key_ignore' },
      ['<leader>p'] = { name = 'Command [P]alette', _ = 'which_key_ignore' },
      ['<leader>td'] = { name = '[D]ebug test', _ = 'which_key_ignore' },
      ['<leader>f'] = { name = '[F]ile', _ = 'which_key_ignore' },
      ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
      ['<leader>ba'] = { name = '[a]ll [b]uffers', _ = 'which_key_ignore' },
      ['<leader>by'] = { name = '[y]ank', _ = 'which_key_ignore' },
      ['<leader>v'] = { name = '[v]isual', _ = 'which_key_ignore' },
      ['<leader>vt'] = { name = '[t]reesitter', _ = 'which_key_ignore' },
    }
  end,
}

return opts
