local opts = {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  commit = '52302f02fea3a490e55475de52fa4deb8af2eb11',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    { 'rcarriga/nvim-dap-ui', commit = 'bc81f8d3440aede116f821114547a476b082b319' },

    -- Required dependency for nvim-dap-ui
    { 'nvim-neotest/nvim-nio' },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    {
      'leoluz/nvim-dap-go',
      config = function()
        require('dap-go').setup {
          delve = {
            build_flags = { '-tags=unit,integration,endtoendtest,smoke' },
          },
        }
      end,
    },
    { 'folke/neodev.nvim', opts = {} },
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    {
      '<leader>tdb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'toggle [d]ebug [b]reakpoint',
    },
    {
      '<leader>tdB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[d]ebug [B]reakpoint',
    },
    {
      '<leader>tdc',
      function()
        require('dap').continue()
      end,
      desc = '[d]ebug [c]ontinue (start here)',
    },
    {
      '<leader>tdC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = '[d]ebug [C]ursor',
    },
    {
      '<leader>tdg',
      function()
        require('dap').goto_()
      end,
      desc = '[d]ebug [g]o to line',
    },
    {
      '<leader>tdo',
      function()
        require('dap').step_over()
      end,
      desc = '[d]ebug step [o]ver',
    },
    {
      '<leader>tdO',
      function()
        require('dap').step_out()
      end,
      desc = '[d]ebug step [O]ut',
    },
    {
      '<leader>tdi',
      function()
        require('dap').step_into()
      end,
      desc = '[d]ebug [i]nto',
    },
    {
      '<leader>tdj',
      function()
        require('dap').down()
      end,
      desc = '[d]ebug [j]ump down',
    },
    {
      '<leader>tdk',
      function()
        require('dap').up()
      end,
      desc = '[d]ebug [k]ump up',
    },
    {
      '<leader>tdl',
      function()
        require('dap').run_last()
      end,
      desc = '[d]ebug [l]ast',
    },
    {
      '<leader>tdp',
      function()
        require('dap').pause()
      end,
      desc = '[d]ebug [p]ause',
    },
    {
      '<leader>tdr',
      function()
        require('dap').repl.toggle()
      end,
      desc = '[d]ebug [r]epl',
    },
    {
      '<leader>tdR',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = '[d]ebug [R]emove breakpoints',
    },
    {
      '<leader>tds',
      function()
        require('dap').session()
      end,
      desc = '[d]ebug [s]ession',
    },
    {
      '<leader>tdT',
      function()
        require('dap').terminate()
      end,
      desc = '[d]ebug [t]erminate',
    },
    {
      '<leader>tdt',
      function()
        require('dapui').toggle { reset = true }
      end,
      desc = '[d]ebug [t]oggle ui',
    },

    {
      '<leader>tde',
      function()
        require('dapui').eval()
      end,
      desc = '[d]ebug [t]oggle ui',
    },
    {
      '<leader>tdw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = '[d]ebug [w]idgets',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    -- golang
    dap.adapters.delve = function(callback, config)
      if config.mode == 'remote' and config.request == 'attach' then
        callback {
          type = 'server',
          host = config.host or '127.0.0.1',
          port = config.port or '38697',
        }
      else
        callback {
          type = 'server',
          port = '${port}',
          executable = {
            command = 'dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
            detached = vim.fn.has 'win32' == 0,
          },
        }
      end
    end

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug test', -- configuration for debugging test files
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
      -- works with go.mod packages and sub packages
      {
        type = 'delve',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
      },
    }
    --
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'codelldb',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<C-b>l', dapui.toggle, { desc = 'Debug: See last session result.' })
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open {}
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close {}
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close {}
    end

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        build_flags = { '-tags=integration,unit,endtoendtest,smoke' },
      },
    }
    vim.api.nvim_set_hl(0, 'blue', { fg = '#3d59a1' })
    vim.api.nvim_set_hl(0, 'green', { fg = '#9ece6a' })
    vim.api.nvim_set_hl(0, 'yellow', { fg = '#FFFF00' })
    vim.api.nvim_set_hl(0, 'orange', { fg = '#f09000' })

    vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'blue', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '•', texthl = 'blue', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '•', texthl = 'orange', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapStopped', { text = '•', texthl = 'green', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '•', texthl = 'yellow', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    require('neodev').setup {
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    }
  end,
}

return opts
