local opts = {
    'echasnovski/mini.files',
    version = '*',
    name = "MiniFiles",
    config = function()
        require('mini.files').setup({})
        local minifiles_toggle = function()
            if not MiniFiles.close() then MiniFiles.open() end
        end
        vim.keymap.set('n', '<leader>tfe', minifiles_toggle, { desc = '[t]oggle [f]ile [e]ditor' })
    end
}

return opts
