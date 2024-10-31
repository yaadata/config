local M = {}

M.get_build_tags = function(buf)
  local tags = {}
  buf = buf or '%'
  local pattern = [[^//\s*[+|(go:)]*build\s\+\(.\+\)]]
  local cnt = vim.fn.getbufinfo(buf)[1]['linecount']
  cnt = math.min(cnt, 10)
  for i = 1, cnt do
    local line = vim.fn.trim(vim.fn.getbufline(buf, i)[1])
    if string.find(line, 'package') then
      break
    end
    local t = vim.fn.substitute(line, pattern, [[\1]], '')
    if t ~= line then -- tag found
      t = vim.fn.substitute(t, [[ \+]], ',', 'g')
      table.insert(tags, t)
    end
  end
  if #tags > 0 then
    return tags
  end
end

local function alternate()
  local file, is_source, is_test = M.is_test_file()
  local alt_file = file
  if is_test then
    alt_file = string.gsub(file, '_test.go', '.go')
  elseif is_source then
    alt_file = vim.fn.expand '%:r' .. '_test.go'
  else
    vim.notify('not a go file', vim.log.levels.ERROR)
  end
  return alt_file
end

M.is_test_file = function()
  local fp = vim.fn.expand '%'
  if #fp <= 1 then
    vim.notify('no buffer name', vim.log.levels.ERROR)
  end
  local is_test = string.find(fp, '_test%.go%')
  local is_source = string.find(fp, '%.go%')
  return fp, (not is_test and is_source), is_test
end

M.get_test_file_bufnr = function()
  local fn = vim.fn.expand '%'
  local bufnr = vim.api.nvim_get_current_buf()
  if not fn:find 'test%.go' then
    fn = alternate()
    fn = vim.fn.fnamemodify(fn, ':p')

    -- check if exist
    if vim.fn.filereadable(fn) then
      vim.notify('no test file found for ' .. fn, vim.log.levels.WARN)
      return 0, 'no test file'
    end

    local uri = vim.uri_from_fname(fn)
    bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end
  end

  return bufnr
end

return M
