local opts = {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        require("flash").setup()
    end,
}

return opts
