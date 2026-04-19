local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require('telescope.config').values

local shared = require 'utils.diff_picker.shared'

local function get_diff_parent_output()
  local lines = vim.fn.systemlist { 'git-town', 'diff-parent' }

  for i, line in ipairs(lines) do
    lines[i] = shared.strip_ansi(line)
  end

  local output = table.concat(lines, '\n')
  if vim.v.shell_error ~= 0 then
    return nil, output
  end

  return lines, nil
end

local function is_diff_parent_tty_error(err)
  local normalized = shared.sanitize_ansi_text(err):lower()
  return normalized:find('could not open a new tty', 1, true) ~= nil or normalized:find('/dev/tty', 1, true) ~= nil
end

local function parse_sections(lines)
  local trim = function(value)
    if not value then
      return value
    end
    return (value:gsub('^%s+', ''):gsub('%s+$', ''))
  end

  local parse_section_header = function(line)
    if line:match '^%s' then
      return nil, nil, nil
    end

    local file, page, language = line:match '^(.-)%s+%-%-%-%s+(%d+/%d+)%s+%-%-%-%s+(.*)$'
    if file and page and language then
      return trim(file), page, trim(language)
    end

    file, language = line:match '^(.-)%s+%-%-%-%s+(.*)$'
    if file and language and file ~= '' and language ~= '' then
      return trim(file), '1/1', trim(language)
    end

    return nil, nil, nil
  end

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

  local parse_unified_diff_path = function(line)
    local left_path, right_path = line:match '^diff %-%-git a/(.-) b/(.-)$'
    if not left_path or not right_path then
      return nil
    end

    if right_path ~= '/dev/null' then
      return trim(right_path)
    end

    if left_path ~= '/dev/null' then
      return trim(left_path)
    end

    return nil
  end

  local parse_unified_hunk_lnum = function(line)
    local right = line:match '^@@ %-[0-9,]+ %+([0-9]+)'
    return tonumber(right)
  end

  local finalize_unified_section = function(section, results)
    if section == nil then
      return
    end

    section.page = '1/1'
    section.language = shared.preview_filetype_for_path(section.file)
    section.lnum = 1

    for _, line in ipairs(section.lines) do
      local lnum = parse_unified_hunk_lnum(line)
      if lnum then
        section.lnum = lnum
        break
      end
    end

    table.insert(results, section)
  end

  local sections = {}
  local current = nil

  for _, line in ipairs(lines) do
    local file, page, language = parse_section_header(line)

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
    elseif line:match '^diff %-%-git ' then
      finalize_unified_section(current, sections)
      current = {
        file = parse_unified_diff_path(line) or 'diff-parent-output',
        lines = { line },
      }
    elseif current ~= nil then
      table.insert(current.lines, line)
    end
  end

  for _, section in ipairs(sections) do
    if section.page then
      section.lnum = find_section_lnum(section.lines)
    end
  end

  if current ~= nil then
    if current.page then
      current.lnum = find_section_lnum(current.lines)
      table.insert(sections, current)
    else
      finalize_unified_section(current, sections)
    end
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

local M = {}

function M.git_diff_parent_picker(opts)
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

    vim.notify('git-town diff-parent failed:\n' .. shared.sanitize_ansi_text(err), vim.log.levels.ERROR)
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
          vim.bo[self.state.bufnr].filetype = shared.preview_filetype_for_section(entry.value)
        end,
      },
    })
    :find()
end

return M
