local opts = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "c",
                "cpp",
                "make",
                "cmake",
                "python",
                "rust",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "ruby",
                "typescript",
                "javascript",
                "json",
                "html",
                "css",
                "scss",
                "sql",
                "proto",
                "thrift",
                "markdown",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { -- This is optional
                enable = true,
            },
        })
    end
}

return opts
