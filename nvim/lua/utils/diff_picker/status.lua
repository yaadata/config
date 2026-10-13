local fzf = require 'fzf-lua'
local path = require 'fzf-lua.path'
local utils = require 'fzf-lua.utils'
local buffer_previewer = require('fzf-lua.previewer.builtin').buffer_or_file
local shared = require 'utils.diff_picker.shared'

local function status_entry(line)
  line = utils.strip_ansi_coloring(line)
  local filename = line:sub(4)
  if line:sub(1, 2):find '[RC]' then
    filename = filename:match '.* -> (.*)' or filename
  end
  if filename:sub(1, 1) == '"' then
    local ok, decoded = pcall(vim.fn.json_decode, filename)
    if ok then
      filename = decoded
    end
  end
  return line:sub(1, 1) .. utils.nbsp .. line:sub(2, 2) .. utils.nbsp .. utils.nbsp .. filename
end

local diff_preview = buffer_previewer:extend()

function diff_preview:close(...)
  self._diff_request = (self._diff_request or 0) + 1
  if self._diff_job then
    self._diff_job:kill(15)
    self._diff_job = nil
  end
  return diff_preview.super.close(self, ...)
end

function diff_preview:populate_preview_buf(entry_str)
  self._diff_request = (self._diff_request or 0) + 1
  local request = self._diff_request
  if self._diff_job then
    self._diff_job:kill(15)
    self._diff_job = nil
  end
  -- Keep the Git path when a buffer exists but is not loaded.
  local entry = self:entry_to_file(entry_str)
  local columns = utils.strsplit(utils.strip_ansi_coloring(entry_str), utils.nbsp)
  local status = (columns[1] or '') .. (columns[2] or '')
  local cmd = path.git_cwd({ 'git', '--no-pager', 'diff' }, self.opts)
  if status:find('?', 1, true) or status:sub(1, 1) == 'A' then
    vim.list_extend(cmd, { '--no-index', '--', '/dev/null', entry.path })
  else
    vim.list_extend(cmd, { 'HEAD', '--', entry.path })
  end
  self._diff_job = vim.system(cmd, { cwd = self.opts.cwd, text = true }, function(result)
    vim.schedule(function()
      if request ~= self._diff_request then
        return
      end
      self._diff_job = nil
      if not self.win or not self.win:validate_preview() then
        return
      end
      local output = result.stdout or ''
      if output == '' then
        output = result.stderr or ''
      end
      local lines = vim.split(output, '\n', { trimempty = true })
      for i, line in ipairs(lines) do
        lines[i] = shared.strip_ansi(line)
      end
      if #lines == 0 then
        lines = { 'No diff output for this file.' }
      end
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      entry.filetype = shared.is_difftastic_output(lines) and shared.preview_filetype_for_path(entry.path) or 'diff'
      entry.line, entry.col = 1, 1
      self:set_preview_buf(bufnr)
      self:preview_buf_post(entry)
    end)
  end)
end

local M = {}

function M.git_status_difftastic_picker(opts)
  opts = vim.tbl_extend('force', {}, opts or {}, {
    previewer = {
      _ctor = function()
        return diff_preview
      end,
    },
    preview = false,
    file_icons = false,
    multiprocess = false,
    fn_transform = status_entry,
  })
  opts.git_dir = opts.git_dir or opts.gitdir
  opts.git_worktree = opts.git_worktree or opts.toplevel
  fzf.git_status(opts)
end

return M
