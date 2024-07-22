local opts = {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>sta",
            ":TodoTelescope cwd=./ <enter>",
            "[S]earch [T]odo [A]ll"
        }
    }
}

return opts
