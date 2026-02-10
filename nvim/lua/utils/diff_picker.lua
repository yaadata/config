local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local from_entry = require 'telescope.from_entry'
local utils = require 'telescope.utils'
local conf = require('telescope.config').values

local git_command = utils.__git_command

local git_difftastic_previewer = function(opts)
  return previewers.new_termopen_previewer {
    title = 'Git Diff Preview',

    get_command = function(entry)
      local command = git_command({ '--no-pager', 'diff' }, opts)

      if entry.status and (entry.status == '??' or entry.status == 'A ') then
        local p = from_entry.path(entry, true, false)
        if p == nil or p == '' then
          return
        end
        table.insert(command, { '--no-index', '/dev/null' })
      else
        table.insert(command, { 'HEAD', '--' })
      end

      return utils.flatten { utils.flatten(command), entry.value }
    end,

    scroll_fn = function(self, direction)
      if not self.state then
        return
      end

      local bufnr = self.state.termopen_bufnr
      -- 0x05 -> <C-e>; 0x19 -> <C-y>
      local input = direction > 0 and string.char(0x05) or string.char(0x19)
      local count = math.abs(direction)

      vim.api.nvim_win_call(vim.fn.bufwinid(bufnr), function()
        vim.cmd([[normal! ]] .. count .. input)
      end)
    end,
  }
end

local M = {}

M.git_status_difftastic_picker = function(opts)
  opts = opts or {}
  opts.previewer = git_difftastic_previewer(opts)
  opts.cache_picker = false

  builtin.git_status(opts)
end

local function strip_ansi(line)
  return line:gsub('\27%[[0-9;]*m', '')
end

local function get_diff_parent_output()
  local lines = vim.fn.systemlist { 'git-town', 'diff-parent' }
  if vim.v.shell_error ~= 0 then
    return nil, table.concat(lines, '\n')
  end

  for i, line in ipairs(lines) do
    lines[i] = strip_ansi(line)
  end

  return lines, nil
end

local function parse_sections(lines)
  local sections = {}
  local current = nil

  for _, line in ipairs(lines) do
    local file, page, language = line:match('^(.-)%s+%-%-%-%s+(%d+/%d+)%s+%-%-%-%s+(.*)$')

    if file and page and language then
      if current ~= nil then
        table.insert(sections, current)
      end

      current = {
        file = file,
        page = page,
        language = language,
        lines = { line },
      }
    elseif current ~= nil then
      table.insert(current.lines, line)
    end
  end

  if current ~= nil then
    table.insert(sections, current)
  end

  if #sections == 0 and #lines > 0 then
    sections = {
      {
        file = 'diff-parent-output',
        page = '1/1',
        language = 'Text',
        lines = lines,
      },
    }
  end

  return sections
end

M.git_diff_parent_picker = function(opts)
  opts = opts or {}

  if vim.fn.executable 'git-town' ~= 1 then
    vim.notify('git-town is not available in PATH', vim.log.levels.ERROR)
    return
  end

  local lines, err = get_diff_parent_output()
  if lines == nil then
    vim.notify('git-town diff-parent failed:\n' .. err, vim.log.levels.ERROR)
    return
  end

  local sections = parse_sections(lines)
  if #sections == 0 then
    vim.notify('No diff-parent output found', vim.log.levels.INFO)
    return
  end

  pickers
    .new(opts, {
      prompt_title = 'Git Town Diff Parent',
      finder = finders.new_table {
        results = sections,
        entry_maker = function(section)
          return {
            value = section,
            ordinal = table.concat({ section.file, section.page, section.language }, ' '),
            display = string.format('%s (%s) [%s]', section.file, section.page, section.language),
            filename = section.file,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer {
        title = 'Diff Parent Preview',
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entry.value.lines)
          vim.bo[self.state.bufnr].filetype = 'diff'
        end,
      },
    })
    :find()
end

return M
