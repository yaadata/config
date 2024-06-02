local opts = {
    "zbirenbaum/copilot.lua",
    config = function()
        require('copilot').setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                yaml = true,
                golang = true,
                rust = true,
                python = true,
                javascript = true,
                typescript = true,
                c = true,
                cpp = true,
            },
        })
    end
}

return opts
