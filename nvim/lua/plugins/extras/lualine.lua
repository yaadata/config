local opts = {

    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('lualine').setup({
            theme = 'palenight',
        })
    end
}

return opts
