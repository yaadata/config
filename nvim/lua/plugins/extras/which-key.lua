local opts = {          -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        require('which-key').setup()

        -- Document existing key chains
        require('which-key').register {
            ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
            ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            ['<leader>h'] = { name = 'Grapple', _ = 'which_key_ignore' },
            ['<leader>ms'] = { name = '[M]ini [S]urround', _ = 'which_key_ignore' },
            ['<leader>l'] = { name = 'Git', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = '[T]est', _ = 'which_key_ignore' },
            ['<leader>td'] = { name = '[D]ebug test', _ = 'which_key_ignore' },
            ['<leader>f'] = { name = '[F]ile', _ = 'which_key_ignore' },
            ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
            ['<leader>bg'] = { name = '[g]oto [b]uffer', _ = 'which_key_ignore' },
            ['<leader>ba'] = { name = '[a]ll [b]uffers', _ = 'which_key_ignore' },
            ['<leader>bc'] = { name = '[c]urrent [b]uffer', _ = 'which_key_ignore' },
        }
    end,
}

return opts
