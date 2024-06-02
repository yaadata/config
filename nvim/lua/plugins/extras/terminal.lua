local opts = {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        direction = 'float',
    },
    config = function()
        require('toggleterm').setup {}
        vim.keymap.set('n', '<leader>tt', ':ToggleTerm<enter>', { desc = 'toggle terminal' })
    end
}

return opts
