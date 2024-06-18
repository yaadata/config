local opts = {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false,   -- This plugin is already lazy
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    rust_analyzer = {
                        completion = {
                            autoimport = {
                                enable = true,
                            },
                        },
                    }
                }
            }
        }
    end
}

-- optional plugin - dots for crate graph
-- install with brew install graphviz

return opts
