local opts = {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "macchiato",
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
    },
    config = function()
        require("catppuccin").setup()
        vim.cmd.colorscheme "catppuccin"
    end
}
return opts
