local builtin = require 'telescope.builtin'
local previewers = require 'telescope.previewers'
local putils = require 'telescope.previewers.utils'
local from_entry = require 'telescope.from_entry'
local utils = require 'telescope.utils'

local shared = require 'utils.diff_picker.shared'

local git_command = utils.__git_command

local function git_diff_command_for_entry(entry, opts)
  local command = git_command({ '--no-pager', 'diff' }, opts)

  if entry.status and (entry.status == '??' or entry.status == 'A ') then
    local path = from_entry.path(entry, true, false)
    if path == nil or path == '' then
      return nil
    end
    table.insert(command, { '--no-index', '/dev/null' })
  else
    table.insert(command, { 'HEAD', '--' })
  end

  return utils.flatten { utils.flatten(command), entry.value }
end

local function git_difftastic_previewer(opts)
  return previewers.new_buffer_previewer {
    title = 'Git Diff Preview',

    get_buffer_by_name = function(_, entry)
      return string.format('%s:%s', entry.status or '', entry.value)
    end,

    define_preview = function(self, entry)
      local cmd = git_diff_command_for_entry(entry, opts)
      if not cmd then
        return
      end

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr, content)
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          if content ~= nil then
            for i, line in ipairs(content) do
              content[i] = shared.strip_ansi(line)
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
          end

          local lines = content or vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local ft = 'diff'
          if shared.is_difftastic_output(lines) then
            local path = from_entry.path(entry, false, false) or entry.value
            ft = shared.preview_filetype_for_path(path)
          end
          putils.highlighter(bufnr, ft, opts)
        end,
      })
    end,
  }
end

local M = {}

function M.git_status_difftastic_picker(opts)
  opts = opts or {}
  opts.previewer = git_difftastic_previewer(opts)
  opts.cache_picker = false

  builtin.git_status(opts)
end

return M
