local opts = {

    'nvim-lualine/lualine.nvim',
    dependencies = {
        {
            'nvim-tree/nvim-web-devicons',
            enabled = true,
        },
        "cbochs/grapple.nvim",
    },
    config = function()
        require('lualine').setup({
            theme = 'palenight',
            sections = {
                lualine_b = {
                    {
                        function()
                            return require("grapple").name_or_index()
                        end,
                        cond = function()
                            return package.loaded["grapple"] and require("grapple").exists()
                        end
                    }
                }
            }
        })
    end
}

return opts
