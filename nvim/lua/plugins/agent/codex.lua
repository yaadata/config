local opts = {
  url = 'https://codeberg.org/yaadata/codex.nvim.git',
  -- version = '2.0.0-beta.2',
  branch = 'config-profiles',
  lazy = false,
  dev = false,
  keys = {
    {
      '<leader>wat',
      function()
        require('codex').session.toggle()
      end,
      desc = 'Agent Harness: Toggle terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wa1',
      function()
        require('codex').set_profile 'default'
        vim.notify 'Agent Harness Profile = default (PI)'
      end,
      desc = 'Agent Harness: PI Harness',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wa2',
      function()
        require('codex').set_profile 'codex'
        vim.notify 'Agent Harness Profile = Codex'
      end,
      desc = 'Agent Harness: Openai Codex',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wa3',
      function()
        require('codex').set_profile 'claude'
        vim.notify 'Agent Harness Profile = Claude'
      end,
      desc = 'Agent Harness: Claude Code',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wap',
      function()
        local op = function()
          require('codex').input.feedkey '<S-Tab>'
        end
        require('codex.builtin').one_off(op)
      end,
      desc = 'Agent Harness: Toggle Plan Mode',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wao',
      function()
        require('codex').session.open(true)
      end,
      desc = 'Agent Harness: Open and focus',
      mode = { 'n', 'v' },
    },
    {
      '<leader>waf',
      function()
        require('codex').session.focus()
      end,
      desc = 'Agent Harness: Focus terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wax',
      function()
        require('codex').session.teardown()
      end,
      desc = 'Agent Harness: teardown session',
      mode = { 'n', 'v' },
    },
    {
      '<leader>waX',
      function()
        require('codex').session.teardown_all()
      end,
      desc = 'Agent Harness: teardown all sessions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>was',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add_file()
        codex.prompt_builder.send()
      end,
      desc = 'Agent Harness: Add current buffer',
      mode = 'n',
    },
    {
      '<leader>was',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add_selection()
        codex.prompt_builder.send()
      end,
      desc = 'Agent Harness: Send selection range',
      mode = 'x',
    },
    {
      '<leader>wal',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add_selection {
          include_lines = true,
        }
        codex.prompt_builder.send()
      end,
      desc = 'Agent Harness: Send Selection',
      mode = { 'n', 'v' },
    },
    {
      '<leader>waR',
      function()
        require('codex.builtin').resume {}
      end,
      desc = 'Agent Harness: Resume session',
      mode = { 'n' },
    },
  },
  config = function()
    local codex = require 'codex'
    local km = require('codex.builtin').keymaps
    local wr = require 'utils.window_resize'
    local default_terminal_keys = {
      ['<C-n>'] = {
        mode = { 't', 'n' },
        action = function()
          vim.cmd 'stopinsert'
        end,
        desc = 'normal mode',
      },
      ['<M-BS>'] = { mode = { 't', 'n' }, action = km.clear_input },
      ['<C-x>'] = { mode = { 't', 'n' }, action = km.toggle },
      ['<C-h>'] = { mode = { 't', 'n' }, action = km.nav_left },
      ['<C-j>'] = { mode = { 't', 'n' }, action = km.nav_down },
      ['<C-k>'] = { mode = { 't', 'n' }, action = km.nav_up },
      ['<C-l>'] = { mode = { 't', 'n' }, action = km.nav_right },
      ['<C-S-Left>'] = {
        mode = { 't', 'n' },
        action = function()
          wr.move_left(2)
        end,
        desc = 'resize buffer to the right',
      },
      ['<C-S-Right>'] = {
        mode = { 't', 'n' },
        action = function()
          wr.move_right(2)
        end,
        desc = 'resize buffer to the left',
      },
      ['<C-S-Up>'] = {
        mode = { 't', 'n' },
        action = function()
          wr.move_up(1)
        end,
        desc = 'increase size upward',
      },
      ['<C-S-Down>'] = {
        mode = { 't', 'n' },
        action = function()
          wr.move_down(1)
        end,
        desc = 'decrease size down',
      },
    }
    codex.setup {
      profiles = {
        default = {
          launch = {
            cmd = { 'pi' },
            env = {},
            cwd = nil,
          },
          auto_start = false,
          terminal = {
            provider = 'auto',
            auto_close = true,
            startup = {
              timeout_ms = 2000, -- max time to wait for startup readiness before dropping queued sends
              retry_interval_ms = 50, -- retry interval while waiting for startup readiness
              grace_ms = 800, -- minimum delay after terminal open before first send
            },
            keymaps = default_terminal_keys,
            provider_opts = {
              snacks = {
                win = {
                  title = ' PI Harness ',
                  position = 'right',
                  title_pos = 'center',
                  width = 0.30,
                  wo = {
                    winbar = ' PI Harness ',
                  },
                  border = 'rounded',
                  footer_keys = true,
                },
              },
              native = {
                window = 'vsplit',
                vsplit = {
                  side = 'right', -- left | right
                  size_pct = 33, -- 10-90
                },
              },
            },
          },
          keymaps = {
            ['<leader>war'] = {
              action = function()
                local op = function()
                  codex.prompt_builder.clear()
                  codex.prompt_builder.add '/readonly'
                  codex.prompt_builder.submit()
                end
                require('codex.builtin').one_off(op)
              end,
              desc = 'Agent Harness: Toggle Read Only Mode',
              mode = { 'n', 'v' },
            },
          },
        },
        codex = {
          launch = {
            cmd = { 'codex' },
            env = {},
            cwd = nil,
          },
          auto_start = false,
          terminal = {
            provider = 'auto',
            auto_close = true,
            startup = {
              timeout_ms = 2000, -- max time to wait for startup readiness before dropping queued sends
              retry_interval_ms = 50, -- retry interval while waiting for startup readiness
              grace_ms = 800, -- minimum delay after terminal open before first send
            },
            keymaps = default_terminal_keys,
            provider_opts = {
              snacks = {
                win = {
                  title = ' Openai Codex ',
                  position = 'float',
                  title_pos = 'center',
                  width = 0.30,
                  wo = {
                    winbar = ' Openai Codex ',
                  },
                  border = 'rounded',
                  footer_keys = true,
                },
              },
              native = {
                window = 'vsplit',
                vsplit = {
                  side = 'right', -- left | right
                  size_pct = 33, -- 10-90
                },
                float = {
                  width_pct = 80,
                  height_pct = 80,
                  border = 'rounded',
                  title = ' OpenAI Codex ',
                  title_pos = 'center',
                },
              },
            },
          },
          keymaps = {
            ['<leader>wac'] = {
              action = function()
                local builtin = require 'codex.builtin'
                builtin.execute_slash_command { command = 'copy' }
                vim.defer_fn(function()
                  if codex.session.is_focused() then
                    codex.session.unfocus()
                  end
                end, 300)
              end,
              desc = 'Agent Harness: Copy Latest Response',
              mode = { 'n' },
            },
            ['<leader>wav'] = {
              action = function()
                local op = function()
                  codex.prompt_builder.clear()
                  codex.prompt_builder.add '/voice'
                  codex.prompt_builder.submit()
                end
                require('codex.builtin').one_off(op)
              end,
              desc = 'Agent Harness: Toggle voice mode',
              mode = 'n',
            },
            ['<leader>wam'] = {
              action = function()
                require('codex.builtin').one_off(function()
                  require('codex').input.feedkey '<A-m>'
                end)
              end,
              desc = 'Agent Harness: Mute Voice Mode',
              mode = 'n',
            },
          },
        },
        claude = {
          launch = {
            cmd = { 'claude' },
            env = {},
            cwd = nil,
          },
          auto_start = false,
          terminal = {
            provider = 'auto',
            auto_close = true,
            startup = {
              timeout_ms = 2000, -- max time to wait for startup readiness before dropping queued sends
              retry_interval_ms = 50, -- retry interval while waiting for startup readiness
              grace_ms = 800, -- minimum delay after terminal open before first send
            },
            keymaps = default_terminal_keys,
            provider_opts = {
              snacks = {
                win = {
                  title = ' Claude Code ',
                  position = 'right',
                  title_pos = 'center',
                  width = 0.30,
                  wo = {
                    winbar = ' Claude Code ',
                  },
                  border = 'rounded',
                  footer_keys = true,
                },
              },
              native = {
                window = 'vsplit',
                vsplit = {
                  side = 'right', -- left | right
                  size_pct = 33, -- 10-90
                },
              },
            },
          },
        },
      },
      log = {
        level = 'debug',
      },
    }
  end,
}

return opts
