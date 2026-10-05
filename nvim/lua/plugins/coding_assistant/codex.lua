local opts = {
  url = 'https://codeberg.org/yaadata/codex.nvim.git',
  version = '2.0.0-alpha.1',
  lazy = false,
  dev = false,
  cmd = {
    'Codex',
    'CodexFocus',
    'CodexClose',
    'CodexClearInput',
    'CodexSendSelection',
    'CodexSendFile',
    'CodexMentionFile',
    'CodexMentionDirectory',
  },
  keys = {
    {
      '<leader>wot',
      function()
        require('codex').session.toggle()
      end,
      desc = 'Codex: Toggle terminal',
      mode = { 'n', 'v' },
    },
    {
      '<C-c>',
      function()
        require('codex').session.toggle()
      end,
      desc = 'Codex: Toggle terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>woo',
      function()
        require('codex').session.open(true)
      end,
      desc = 'Codex: Open and focus',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wof',
      function()
        require('codex').session.focus()
      end,
      desc = 'Codex: Focus terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wox',
      function()
        require('codex').session.close()
      end,
      desc = 'Codex: Close session',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wov',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add '/voice'
        codex.prompt_builder.submit()
      end,
      desc = 'Codex: Toggle voice mode',
      mode = 'n',
    },
    {
      '<leader>wom',
      function()
        local codex = require 'codex'
        codex.session.focus()
        codex.input.feedkey '<A-m>'
      end,
      desc = 'Codex: Mute Voice Mode',
      mode = 'n',
    },
    {
      '<leader>wos',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add_file()
        codex.prompt_builder.send()
      end,
      desc = 'Codex: Add current buffer',
      mode = 'n',
    },
    {
      '<leader>wos',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add_selection()
        codex.prompt_builder.send()
      end,
      desc = 'Codex: Send selection',
      mode = 'x',
    },
    {
      '<leader>woM',
      function()
        local codex = require 'codex'
        local builtin = require 'codex.builtin'
        builtin.mention_file()
        vim.defer_fn(function()
          codex.session.unfocus()
        end, 350)
      end,
      desc = 'Codex: Mention current file',
      mode = { 'n', 'v' },
    },
    {
      '<leader>woi',
      function()
        local codex = require 'codex'
        codex.prompt_builder.add '/status '
        codex.prompt_builder.submit()
      end,
      desc = 'Codex: Show status',
      mode = { 'n', 'v' },
    },
    {
      '<leader>wor',
      function()
        local codex = require 'codex'
        local ok, err = codex.prompt_builder.add_selection()
        if not ok then
          vim.notify(('Codex: failed to collect selection%s'):format(err and (': ' .. err) or ''), vim.log.levels.ERROR)
          return
        end
        codex.prompt_builder.add ' do an adversal review for MAJOR gaps in this implementation. Be balanced and quick'
        codex.prompt_builder.send()
        codex.session.focus()
      end,
      desc = 'Codex: Review Code',
      mode = { 'v' },
    },
    {
      '<leader>wor',
      function()
        require('codex.builtin').resume()
      end,
      desc = 'Codex: Resume session',
      mode = { 'n' },
    },
    {
      '<leader>woc',
      function()
        local codex = require 'codex'
        local ok, err = codex.prompt_builder.add_selection()
        if not ok then
          vim.notify(('Codex: failed to collect selection%s'):format(err and (': ' .. err) or ''), vim.log.levels.ERROR)
          return
        end
        local builtin = require 'codex.builtin'
        local skill, format_err = builtin.format_skill {
          plugin = 'code',
          name = 'comment',
        }
        if format_err ~= nil then
          vim.notify(('Codex: failed to format skill%s'):format(err and (': ' .. err) or ''), vim.log.levels.ERROR)
          return
        end
        codex.prompt_builder.add(skill)
        codex.prompt_builder.submit()
      end,
      desc = 'Codex: Add Code Comment',
      mode = { 'v' },
    },
    {
      '<leader>woc',
      function()
        local builtin = require 'codex.builtin'
        builtin.execute_slash_command { command = 'copy' }
        vim.defer_fn(function()
          local codex = require 'codex'
          if codex.session.is_focused() then
            codex.session.unfocus()
          end
        end, 300)
      end,
      desc = 'Codex: Copy Latest Response',
      mode = { 'n' },
    },
  },
  opts = {
    launch = {
      cmd = 'codex',
      args = {},
      env = {},
      auto_start = false,
      cwd = nil,
    },
    log = {
      level = 'debug',
      verbose = true,
    },
    terminal = {
      provider = 'auto',
      auto_close = true,
      startup = {
        timeout_ms = 2000, -- max time to wait for startup readiness before dropping queued sends
        retry_interval_ms = 50, -- retry interval while waiting for startup readiness
        grace_ms = 800, -- minimum delay after terminal open before first send
      },
      provider_opts = {
        snacks = {
          win = {
            title = ' Openai Codex ',
            position = 'right',
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
          hsplit = {
            side = 'bottom', -- top | bottom
            size_pct = 30, -- 10-90
          },
        },
      },
    },
  },
  config = function(_, opts)
    local km = require('codex.builtin').keymaps
    local wr = require 'utils.window_resize'
    opts.terminal.keymaps = {
      ['<C-c>'] = { mode = { 't', 'n' }, action = km.toggle },
      ['<C-n>'] = {
        mode = { 't', 'n' },
        action = function()
          vim.cmd 'stopinsert'
        end,
        desc = 'normal mode',
      },
      ['<M-BS>'] = { mode = { 't', 'n' }, action = km.clear_input },
      ['<C-G>'] = { mode = { 't', 'n' }, action = km.unfocus },
      ['<C-x>'] = { mode = { 't', 'n' }, action = km.close },
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
    require('codex').setup(opts)
  end,
}

return opts
