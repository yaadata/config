local opts = {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        direction = 'float',
    },
    config = function()
        require('toggleterm').setup({
            open_mapping = [[<c-\>]],
        })
    end
}

return opts
