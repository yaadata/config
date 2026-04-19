local M = {}

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

function M.strip_ansi(line)
  return line:gsub('\27%[[0-9;]*m', '')
end

function M.sanitize_ansi_text(text)
  if not text then
    return ''
  end

  return M.strip_ansi(text):gsub('%f[%[]%[[0-9;]*m', '')
end

function M.preview_filetype_for_path(path)
  if not path or path == '' then
    return 'diff'
  end

  local ft = vim.filetype.match { filename = path }
  if ft and ft ~= '' then
    return ft
  end

  return 'diff'
end

function M.preview_filetype_for_language(language)
  language = (language or ''):lower()
  return filetype_by_language[language] or 'diff'
end

function M.preview_filetype_for_section(section)
  if section and section.file then
    return M.preview_filetype_for_path(section.file)
  end

  return M.preview_filetype_for_language(section and section.language)
end

function M.is_difftastic_output(lines)
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

return M
