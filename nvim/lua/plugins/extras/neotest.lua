local opts = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        'mrcjkb/rustaceanvim',
        "fredrikaverpil/neotest-golang",
        "nvim-neo-tree/neo-tree.nvim",
        "nvim-neotest/neotest-plenary",
    },
    keys = {
        {
            "<leader>ta",
            function()
                require("neotest").run.attach()
            end,
            desc = "Attach",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run File",
        },
        {
            "<leader>tA",
            function()
                require("neotest").run.run(vim.uv.cwd())
            end,
            desc = "Run All Test Files",
        },
        {
            "<leader>tT",
            function()
                require("neotest").run.run({ suite = true })
            end,
            desc = "Run Test Suite",
        },
        {
            "<leader>tn",
            function()
                require("neotest").run.run()
            end,
            desc = "Run Nearest",
        },
        {
            "<leader>tl",
            function()
                require("neotest").run.run_last()
            end,
            desc = "Run Last",
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle Summary",
        },
        {
            "<leader>to",
            function()
                require("neotest").output.open({ enter = true, auto_close = true })
            end,
            desc = "Show Output",
        },
        {
            "<leader>tO",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle Output Panel",
        },
        {
            "<leader>tt",
            function()
                require("neotest").run.stop()
            end,
            desc = "Terminate",
        },
        {
            "<leader>td",
            function()
                vim.cmd("Neotree close")
                require("neotest").summary.close()
                require("neotest").output_panel.close()
                require("neotest").run.run({ suite = false, strategy = "dap" })
            end,
            desc = "Debug nearest test",
        },
    },
    config = function()
        local cfg = {
            go = {
                go_test_args = {
                    "-v",
                    "-race",
                    "-count=1",
                    "-tags=integration,unit,endtoendtest,smoke",
                },
            }
        }
        require('neotest').setup({
            adapters = {
                require('neotest-plenary'),
                require('rustaceanvim.neotest'),
                require('neotest-golang')(cfg.go),
            },
            state = {
                enabled = false,
            },
        })
    end
}

return opts
