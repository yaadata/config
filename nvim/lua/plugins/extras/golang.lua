local opts = {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    config = function()
        require("go").setup {
            lsp_inlay_hints = {
                enable = false,
            },
            lsp_cfg = {
                settings = {
                    gopls = {
                        usePlaceholders = false,
                        analyses = {
                            ST1003 = false,
                        },
                        buildFlags = { '-tags', 'integration,unit,endtoendtest,smoke' },
                    },
                },
            },
        }
    end,
}
return opts
