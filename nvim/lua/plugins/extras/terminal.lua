local opts = {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function(opts)
        require('toggleterm').setup({
            direction = 'float',
            open_mapping = [[<c-\>]],
        })
    end
}

return opts
