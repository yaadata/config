local opts = {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}
        vim.keymap.set('n', '<leader>tft', ':NvimTreeToggle<enter>', { desc = '[t]oggle [f]ile tree' })
    end,
}

return opts
