local go_ts = require 'overseer.template.golang.utils.treesitter.helper'
local utils = require 'utils.utensils'

M = {}

M.get_test_func_name = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row, col = row, col + 1
  local node = go_ts.get_func_method_node_at_pos()
  if utils.empty(node) then
    return nil
  end

  if not node or not node.name then
    return nil
  end

  if not string.match(node.name, '[T|t]test') then
    -- not in a test function
    local test_func = M.get_test_func()
    for _, func in ipairs(test_func) do
      if string.find(func:lower(), func.name:lower()) then
        node = { name = func }
        return node
      end
    end
  end
  return node
end

M.get_testfunc = function()
  local bufnr = M.get_test_filebufnr()

  -- Note: the buffer may not be loaded yet
  local parser = vim.treesitter.get_parser(bufnr, 'go')
  if not parser then
    vim.notify('go treesitter parser not found for ' .. vim.fn.bufname(), vim.log.levels.WARN)
    return nil
  end
  local tree = parser:parse()[1]
  local query = vim.treesitter.parse('go', require('go.ts.go').query_test_func)

  local test_names = {}

  -- local get_node_text = vim.treesitter.get_node_text
  for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = vim.treesitter.query.captures[id] -- name of the capture in the query
    if name == 'test_name' then
      table.insert(test_names, utils.get_node_text(node, bufnr))
    end
  end
  return test_names
end

M.alternate = function()
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

M.get_test_filebufnr = function()
  local filename = vim.fn.expand '%'

  local bufnr = vim.api.nvim_get_current_buf()
  if not filename:find 'test%.go$' then
    filename = M.alternate()
    local file_path = vim.fn.fnamemodify(filename, ':p') -- full file path
    local uri = vim.uri_to_fname(file_path)
    bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end
  end

  return bufnr
end

M.get_testcase_name = function()
  local name = go_ts.get_table_testcase_node_name()
  if not utils.empty(name) then
    return name
  end

  name = go_ts.get_sub_testcase_name()
  if not utils.empty(name) then
    return name
  end

  return nil
end

M.get_test_path = function()
  local path = vim.fn.expand '%:p:h'
  local relative_path = vim.fn.fnamemodify(path, ':.')
  if path == relative_path then
    return path
  end
  -- TODO: this line is Operating System dependent
  return './' .. relative_path
end

return M
