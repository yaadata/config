local fzf = require 'fzf-lua'
local previewers = require 'fzf-lua.previewer.builtin'

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

    if section.page then
      section.lnum = section.lnum or find_section_lnum(section.lines)
      table.insert(results, section)
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
        finalize_unified_section(current, sections)
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
    if section.page and section.lnum == nil then
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

  local entries = {}
  for index, section in ipairs(sections) do
    entries[index] = string.format('%d\t%s:%d (%s) [%s]', index, section.file, section.lnum, section.page, section.language)
  end

  local section_for_entry = function(entry)
    local index = tonumber(shared.strip_ansi(entry):match '^(%d+)\t')
    return sections[index]
  end

  local Previewer = previewers.buffer_or_file:extend()
  function Previewer:populate_preview_buf(entry)
    local section = section_for_entry(entry)
    if not section then
      return
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[bufnr].bufhidden = 'wipe'
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, section.lines)
    vim.bo[bufnr].filetype = shared.preview_filetype_for_section(section)
    self:set_preview_buf(bufnr, true)
    self.win:update_preview_title ' Diff Parent Preview '
  end

  local file_action = function(action)
    return function(selected, action_opts)
      local files = {}
      for _, entry in ipairs(selected) do
        local section = section_for_entry(entry)
        if section then
          files[#files + 1] = string.format('%s:%d:1:', section.file, section.lnum)
        end
      end
      if #files > 0 then
        action(files, action_opts)
      end
    end
  end

  local picker_opts = vim.tbl_deep_extend('force', {
    prompt = 'Git Town Diff Parent> ',
    cwd = vim.fn.getcwd(),
    fzf_opts = {
      ['--delimiter'] = '\t',
      ['--with-nth'] = '2..',
      ['--multi'] = true,
    },
    previewer = {
      _ctor = function()
        return Previewer
      end,
    },
    actions = {
      ['enter'] = file_action(fzf.actions.file_edit_or_qf),
      ['ctrl-x'] = file_action(fzf.actions.file_split),
      ['ctrl-v'] = file_action(fzf.actions.file_vsplit),
      ['ctrl-t'] = file_action(fzf.actions.file_tabedit),
      ['alt-q'] = file_action(fzf.actions.file_sel_to_qf),
    },
  }, opts)
  fzf.fzf_exec(entries, picker_opts)
end

return M
