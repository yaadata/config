local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local putils = require 'telescope.previewers.utils'
local from_entry = require 'telescope.from_entry'
local utils = require 'telescope.utils'
local conf = require('telescope.config').values

local git_command = utils.__git_command

local function strip_ansi(line)
  return line:gsub('\27%[[0-9;]*m', '')
end

local function sanitize_ansi_text(text)
  if not text then
    return ''
  end

  return strip_ansi(text):gsub('%f[%[]%[[0-9;]*m', '')
end

local filetype_by_language = {
  c = 'c',
  cpp = 'cpp',
  fish = 'fish',
  go = 'go',
  java = 'java',
  javascript = 'javascript',
  json = 'json',
  lua = 'lua',
  markdown = 'markdown',
  python = 'python',
  rust = 'rust',
  sh = 'sh',
  shell = 'sh',
  terraform = 'terraform',
  text = 'text',
  toml = 'toml',
  typescript = 'typescript',
  yaml = 'yaml',
}

local function preview_filetype_for_path(path)
  if not path or path == '' then
    return 'diff'
  end

  local ft = vim.filetype.match { filename = path }
  if ft and ft ~= '' then
    return ft
  end

  return 'diff'
end

local function preview_filetype_for_language(language)
  language = (language or ''):lower()
  return filetype_by_language[language] or 'diff'
end

local function is_difftastic_output(lines)
  if not lines or #lines == 0 then
    return false
  end

  local max_check = math.min(#lines, 40)
  for i = 1, max_check do
    if lines[i]:match '^.+%s+%-%-%-%s+%d+/%d+%s+%-%-%-%s+.+$' then
      return true
    end
  end

  return false
end

local function git_diff_command_for_entry(entry, opts)
  local command = git_command({ '--no-pager', 'diff' }, opts)

  if entry.status and (entry.status == '??' or entry.status == 'A ') then
    local p = from_entry.path(entry, true, false)
    if p == nil or p == '' then
      return nil
    end
    table.insert(command, { '--no-index', '/dev/null' })
  else
    table.insert(command, { 'HEAD', '--' })
  end

  return utils.flatten { utils.flatten(command), entry.value }
end

local git_difftastic_previewer = function(opts)
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
              content[i] = strip_ansi(line)
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
          end

          local lines = content or vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local ft = 'diff'
          if is_difftastic_output(lines) then
            local path = from_entry.path(entry, false, false) or entry.value
            ft = preview_filetype_for_path(path)
          end
          putils.highlighter(bufnr, ft, opts)
        end,
      })
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

local function get_diff_parent_output()
  local lines = vim.fn.systemlist { 'git-town', 'diff-parent' }

  for i, line in ipairs(lines) do
    lines[i] = strip_ansi(line)
  end

  local output = table.concat(lines, '\n')
  if vim.v.shell_error ~= 0 then
    return nil, output
  end

  return lines, nil
end

local function is_diff_parent_tty_error(err)
  local normalized = sanitize_ansi_text(err):lower()
  return normalized:find('could not open a new tty', 1, true) ~= nil or normalized:find('/dev/tty', 1, true) ~= nil
end

local function parse_sections(lines)
  local parse_diff_line_numbers = function(line)
    local left, right = line:match '^%s*([%.%d]+)%s+([%.%d]+)'
    if not left or not right then
      return nil, nil
    end

    if not left:match '^%d+$' then
      left = nil
    end
    if not right:match '^%d+$' then
      right = nil
    end

    return tonumber(left), tonumber(right)
  end

  local find_section_lnum = function(section_lines)
    local first_right = nil
    local first_left = nil

    for i = 2, #section_lines do
      local left, right = parse_diff_line_numbers(section_lines[i])
      if left or right then
        first_right = first_right or right
        first_left = first_left or left

        if left ~= right then
          return right or left
        end
      end
    end

    return first_right or first_left or 1
  end

  local sections = {}
  local current = nil

  for _, line in ipairs(lines) do
    local file, page, language = line:match '^(.-)%s+%-%-%-%s+(%d+/%d+)%s+%-%-%-%s+(.*)$'

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

  for _, section in ipairs(sections) do
    section.lnum = find_section_lnum(section.lines)
  end

  if #sections == 0 and #lines > 0 then
    sections = {
      {
        file = 'diff-parent-output',
        page = '1/1',
        language = 'Text',
        lines = lines,
        lnum = 1,
      },
    }
  end

  return sections
end

local function preview_filetype_for_section(section)
  if section and section.file then
    return preview_filetype_for_path(section.file)
  end

  return preview_filetype_for_language(section and section.language)
end

M.git_diff_parent_picker = function(opts)
  opts = opts or {}

  if vim.fn.executable 'git-town' ~= 1 then
    vim.notify('git-town is not available in PATH', vim.log.levels.ERROR)
    return
  end

  local lines, err = get_diff_parent_output()
  if lines == nil then
    if is_diff_parent_tty_error(err) then
      vim.notify('git-town not setup. complete setup in terminal first.', vim.log.levels.WARN)
      return
    end

    vim.notify('git-town diff-parent failed:\n' .. sanitize_ansi_text(err), vim.log.levels.ERROR)
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
            display = string.format('%s:%d (%s) [%s]', section.file, section.lnum, section.page, section.language),
            filename = section.file,
            lnum = section.lnum,
            col = 1,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer {
        title = 'Diff Parent Preview',
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entry.value.lines)
          vim.bo[self.state.bufnr].filetype = preview_filetype_for_section(entry.value)
        end,
      },
    })
    :find()
end

return M
