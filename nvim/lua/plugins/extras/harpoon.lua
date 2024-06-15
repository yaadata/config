local opts = {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup({})

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>hho", function() toggle_telescope(harpoon:list()) end,
            { desc = "[H]arpoon open list" })
        vim.keymap.set("n", "<leader>hhr", function() harpoon:list():remove() end,
            { desc = "[H]arpoon [R]emove marker" })
        vim.keymap.set("n", "<leader>hha", function() harpoon:list():add() end, {
            desc = "[H]arpon [A]dd marker",
        })
        vim.keymap.set("n", "<leader>hhc", function() harpoon:list():clear() end, {
            desc = "[H]arpoon [C]lear all markers",
        })
        vim.keymap.set("n", "<leader>hhp", function() harpoon:list():prev() end, {
            desc = "[H]arpoon [P]revious marker",
        })
        vim.keymap.set("n", "<leader>hhn", function() harpoon:list():next() end, {
            desc = "[H]arpoon [N]ext marker",
        })
        vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, {
            desc = "[H]arpoon go to marker [1]",
        })
        vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, {
            desc = "[H]arpoon go to marker [2]",
        })
        vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, {
            desc = "[H]arpoon go to marker [3]",
        })
        vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, {
            desc = "[H]arpoon go to marker [4]",
        })
    end
}

return opts
