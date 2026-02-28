local opts = {
  'stevearc/oil.nvim',
  opts = {},
  commit = 'f55b25e493a7df76371cfadd0ded5004cb9cd48a',
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons', { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    local preview_enabled = false
    local oil = require 'oil'
    local MAX_WIDTH = 0.85
    local MAX_HEIGHT = 0.75
    local function warn(msg)
      vim.notify(msg, vim.log.levels.WARN)
    end
    oil.setup {
      float = {
        max_width = MAX_WIDTH,
        max_height = MAX_HEIGHT,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        override = function(conf)
          local ui = vim.api.nvim_list_uis()[1]
          conf.width = math.floor(ui.width * MAX_WIDTH)
          conf.height = math.floor(ui.height * MAX_HEIGHT)
          conf.row = math.floor(ui.height * (1 - MAX_HEIGHT) / 2)
          conf.col = math.floor(ui.width * (1 - MAX_WIDTH) / 2)
          return conf
        end,
      },
      silence_scp_warning = true,
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['gp'] = {
          desc = 'Toggle Preview',
          callback = function()
            if not preview_enabled then
              require('oil').open_preview {
                vertical = true,
                split = 'botright',
              }
              preview_enabled = true
            else
              vim.cmd.pclose()
              preview_enabled = false
              -- removing the preview buffer cuts the width in half,
              -- we need to resize the existing oil buffer back to its
              -- original settings
              local win = vim.api.nvim_get_current_win()
              local ui = vim.api.nvim_list_uis()[1]
              vim.api.nvim_win_set_config(win, {
                relative = 'editor',
                width = math.floor(ui.width * MAX_WIDTH),
                height = math.floor(ui.height * MAX_HEIGHT),
                row = math.floor(ui.height * (1 - MAX_HEIGHT) / 2),
                col = math.floor(ui.width * (1 - MAX_WIDTH) / 2),
              })
            end
          end,
        },
        ['gh'] = {
          desc = 'Toggle [H]idden',
          callback = function()
            require('oil').toggle_hidden()
          end,
        },
        ['<M-m>'] = {
          desc = 'Codex: Mention selected file',
          mode = 'n',
          callback = function()
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir(0)
            if not entry or not dir then
              warn 'Oil: unable to resolve selected file'
              return
            end
            if entry.type == 'directory' then
              warn 'Oil: selected entry is a directory; use Alt+Shift+M'
              return
            end

            local ok, err = require('codex').mention_file(dir .. entry.name, {
              post_execute = function(callback_ok, _)
                if callback_ok then
                  vim.defer_fn(function()
                    oil.toggle_float(dir)
                  end, 1000)
                end
              end,
            })
            if not ok then
              warn(string.format('Oil: failed to mention file (%s)', err or 'unknown error'))
              return
            end
          end,
        },
        ['s'] = {
          desc = 'Codex: send selected file `@`',
          mode = 'n',
          callback = function()
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir(0)
            if not entry or not dir then
              warn 'Oil: unable to resolve selected file'
              return
            end
            if entry.type == 'directory' then
              warn 'Oil: selected entry is a directory; use Alt+Shift+M'
              return
            end
            local fp = dir .. entry.oname
            local ok, err = require('codex').send_buffer { path = fp, focus = false }
            if not ok then
              warn(string.format('Oil: failed to inline send file path (%s)', err or 'unknown error'))
              return
            end
          end,
        },
        ['<M-S-m>'] = {
          desc = 'Codex: Mention current directory',
          mode = 'n',
          callback = function()
            local dir = oil.get_current_dir(0)
            if not dir then
              warn 'Oil: unable to resolve current directory'
              return
            end

            local ok, err = require('codex').mention_directory(dir, {
              post_execute = function(callback_ok, _)
                if callback_ok then
                  vim.defer_fn(function()
                    oil.toggle_float(dir)
                  end, 1000)
                end
              end,
            })
            if not ok then
              warn(string.format('Oil: failed to mention directory (%s)', err or 'unknown error'))
              return
            end
          end,
        },
      },
    }
    vim.keymap.set('n', '<leader>fo', function()
      oil.toggle_float()
    end, { desc = 'Open Oil for current directory' })
  end,
}

return opts
