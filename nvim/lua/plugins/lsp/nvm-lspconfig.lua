local opts = { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  tag = 'v2.3.0',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', tag = 'v1.11.0' },
    { 'mason-org/mason-lspconfig.nvim', tag = 'v1.32.0' },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'jmacadie/telescope-hierarchy.nvim', commit = '2ba4840d8ba9288ca85dc34b01cf946aee0b8fca' },
  },
  config = function()
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    local builtin = require 'telescope.builtin'
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local function on_list(options)
          vim.fn.setqflist({}, ' ', options)
          builtin.quickfix()
        end
        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', function()
          vim.lsp.buf.definition { on_list = on_list }
        end, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', function()
          vim.lsp.buf.references(nil, { on_list = on_list })
        end, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', function()
          vim.lsp.buf.implementation { on_list = on_list }
        end, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>ld', vim.lsp.buf.type_definition, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ls', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>lws', vim.lsp.buf.workspace_symbol, '[W]orkspace symbols')

        -- Add folder to workspace folders list
        map('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[A]dd [W]orkspace Folder')

        -- Remove folder to workspace folders list
        map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[R]emove [W]orkspace Folder')

        map('<leader>lhi', '<cmd>Telescope hierarchy incoming_calls<cr>', '[I]ncoming Calls')
        map('<leader>lho', '<cmd>Telescope hierarchy outgoing_calls<cr>', '[O]utgoing Calls')

        -- List workspace folders
        map('<leader>lwl', vim.lsp.buf.list_workspace_folders, '[L]ist [W]orkspace folders')

        -- format buffer
        map('<leader>lf', vim.lsp.buf.format, '[F]ormat')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Inlay hints
        map('<leader>li', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[C]ode [I]nlay Hints')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local nvim_lsp = require 'lspconfig'

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- clangd = {},
      gopls = {
        cmd = { 'gopls', '--remote=auto' },
        settings = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            ST1003 = false,
          },
          buildFlags = { 'tags=integration,unit,endtoendtest,smoke' },
        },
        init_options = {
          buildFlags = { '-tags=integration,unit,endtoendtest,smoke' },
        },
      },
      denols = {
        root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
        root_markers = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
      },
      ts_ls = {
        root_dir = nvim_lsp.util.root_pattern 'package.json',
        single_file_support = false,
      },
      starpls = {
        filetypes = { 'bzl', 'bazel', 'sy' },
      },
      terraformls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files and plugins
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
      ruby_lsp = {
        init_options = {
          formatter = 'standard',
          linters = { 'standard' },
        },
        cmd = { 'mise', 'x', '--', 'ruby-lsp' },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = {
      'bash-language-server',
      'black',
      'buf',
      'codelldb',
      'css-lsp',
      'debugpy',
      'deno',
      'go-debug-adapter',
      'goimports',
      'golangci-lint',
      'gotests',
      'gotestsum',
      'graphql-language-service-cli',
      -- 'html-lsp',
      'lua-language-server',
      'markdownlint',
      'markdownlint',
      'protolint',
      'pydocstyle',
      'pyright',
      'eslint_d',
      'starpls',
      'sql-formatter',
      'sqlfmt',
      'stylua',
      'terraform-ls',
      'vetur-vls',
      'yaml-language-server',
      'typescript-language-server',
      'zls',
    }
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          local capabilities = require('blink.cmp').get_lsp_capabilities()
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          nvim_lsp[server_name].setup(server)
        end,
      },
    }
    require('neodev').setup {
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    }
  end,
}

return opts
