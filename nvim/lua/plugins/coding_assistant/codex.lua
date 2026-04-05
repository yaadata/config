local opts = {
  'yaadata/codex.nvim',
  version = '1.0.0',
  cmd = {
    'Codex',
    'CodexFocus',
    'CodexClose',
    'CodexClearInput',
    'CodexSendSelection',
    'CodexSendFile',
    'CodexMentionFile',
    'CodexMentionDirectory',
    'CodexResume',
  },
  keys = {
    {
      '<leader>aot',
      function()
        require('codex').toggle()
      end,
      desc = 'Codex: Toggle terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoo',
      function()
        require('codex').open(true)
      end,
      desc = 'Codex: Open and focus',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aof',
      function()
        require('codex').focus()
      end,
      desc = 'Codex: Focus terminal',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aox',
      function()
        require('codex').close()
      end,
      desc = 'Codex: Close session',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aos',
      function()
        require('codex').send_file()
      end,
      desc = 'Codex: Add current buffer',
      mode = 'n',
    },
    {
      '<leader>aos',
      function()
        require('codex').send_selection()
      end,
      desc = 'Codex: Send selection',
      mode = 'x',
    },
    {
      '<leader>aom',
      function()
        local codex = require 'codex'
        codex.mention_file()
        vim.defer_fn(function()
          codex.unfocus()
        end, 350)
      end,
      desc = 'Codex: Mention current file',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoM',
      function()
        local codex = require 'codex'
        codex.mention_directory()
        vim.defer_fn(function()
          if codex.is_focused() then
            codex.unfocus()
          end
        end, 350)
      end,
      desc = 'Codex: Mention current directory',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aoi',
      function()
        require('codex').execute_slash_command { command = 'status' }
      end,
      desc = 'Codex: Show status',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aor',
      function()
        local codex = require 'codex'
        local ok, err = codex.send_selection()
        if not ok then
          vim.notify(('Codex: failed to collect selection%s'):format(err and (': ' .. err) or ''), vim.log.levels.ERROR)
          return
        end
        codex.send '$code-review the current selection '
        codex.submit_input()
      end,
      desc = 'Codex: Review Code',
      mode = { 'v' },
    },
    {
      '<leader>aor',
      function()
        require('codex').resume()
      end,
      desc = 'Codex: Resume session',
      mode = { 'n' },
    },
    {
      '<leader>aoc',
      function()
        local codex = require 'codex'
        local ok, err = codex.send_selection()
        if not ok then
          vim.notify(('Codex: failed to collect selection%s'):format(err and (': ' .. err) or ''), vim.log.levels.ERROR)
          return
        end
        codex.send '$code-comment the current selection '
        codex.submit_input()
      end,
      desc = 'Codex: Add Code Coment',
      mode = { 'v' },
    },
    {
      '<leader>aoc',
      function()
        local codex = require 'codex'
        codex.execute_slash_command { command = 'copy' }
        vim.defer_fn(function()
          if codex.is_focused() then
            codex.unfocus()
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
            size_pct = 30, -- 10-90
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
    local km = require('codex.keymaps').builtins
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
