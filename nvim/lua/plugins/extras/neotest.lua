local opts = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        'mrcjkb/rustaceanvim',
        {
            "fredrikaverpil/neotest-golang", -- Installation
            dependencies = {
                "leoluz/nvim-dap-go",
            },
        },
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
            "<leader>tdn",
            function()
                vim.cmd("Neotree close")
                require("neotest").summary.close()
                require("neotest").output_panel.close()
                require("neotest").run.run({ suite = false, strategy = "dap" })
            end,
            desc = "Debug nearest test",
        },
    },
    opts = function(_, opts)
        opts.adapters = opts.adapters or {}
        opts.adapters["neotest-golang"] = {
            go_test_args = {
                "-v",
                "-race",
                "-count=1",
                "-tags=integration,unit,endtoendtest,smoke",
            },
            dap_go_opts = {
                delve = {
                    build_flags = { "-tags=integration,unit,endtoendtest,smoke" },
                }
            },
        }
        opts.adapters['neotest-plenary'] = {}
        opts.adapters['rustaceanvim.neotest'] = {}
    end,
    config = function(_, opts)
        if opts.adapters then
            local adapters = {}
            for name, config in pairs(opts.adapters or {}) do
                if type(name) == "number" then
                    if type(config) == "string" then
                        config = require(config)
                    end
                    adapters[#adapters + 1] = config
                elseif config ~= false then
                    local adapter = require(name)
                    if type(config) == "table" and not vim.tbl_isempty(config) then
                        local meta = getmetatable(adapter)
                        if adapter.setup then
                            adapter.setup(config)
                        elseif adapter.adapter then
                            adapter.adapter(config)
                            adapter = adapter.adapter
                        elseif meta and meta.__call then
                            adapter(config)
                        else
                            error("Adapter " .. name .. " does not support setup")
                        end
                    end
                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
        end

        require("neotest").setup(opts)
    end,
}

return opts
