local parsers = require('nvim-treesitter').parsers
local M = {}

function M.regex_get_all_tests()
  local tests = {}
  local current_buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)

  -- Pattern to match Go test functions
  -- Matches both Test* and Benchmark* functions
  local test_pattern = '^func%s+(Test%w+)%s*%(.*%)%s*{'
  local benchmark_pattern = '^func%s+(Benchmark%w+)%s*%(.*%)%s*{'
  local subtest_pattern = 't%.Run%s*%(?%s*["`]([^"`]+)["`]'

  local current_test = nil
  local brace_count = 0

  for i, line in ipairs(lines) do
    local test_name = line:match(test_pattern)
    local subtest_name = line:match(subtest_pattern)
    local benchmark_name = line:match(benchmark_pattern)

    -- Count braces to track test function scope
    brace_count = brace_count + #(line:gsub('[^{]', ''))
    brace_count = brace_count - #(line:gsub('[^}]', ''))

    if test_name then
      current_test = {
        name = test_name,
        line = i,
        type = 'test',
        subtests = {},
        end_line = nil,
      }
      table.insert(tests, current_test)
    elseif benchmark_pattern then
      current_test = {
        name = benchmark_name,
        line = i,
        type = 'benchmark',
        subtests = {},
        end_line = nil,
      }
      table.insert(tests, current_test)
    elseif subtest_name and current_test then
      table.insert(current_test.subtests, {
        name = subtest_name,
        line = i,
        parent = current_test.name,
      })
    end
    -- mark test end when brace count returns to 0
    if current_test and brace_count == 0 then
      current_test.end_line = i
      current_test = nil
    end
  end

  return tests
end

function M.get_function_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- treesitter is 0 index and vim api is 1-index

  -- Ensure go parser works
  local lang_tree = vim.treesitter.get_parser(bufnr, 'go')
  if not lang_tree then
    vim.notify('Treesitter Go parser is not installed', vim.log.levels.ERROR)
    return nil
  end

  -- walk up the tree
  local tree = lang_tree:parse()[1]
  local root = tree:root()
  local cursor_node = root:named_descendant_for_range(row, col, row, col)

  local node = cursor_node
  while node do
    if node:type() == 'function_declaration' then
      return node
    end
    node = node:parent()
  end
end

function M.get_subtest_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- treesitter is 0 index and vim api is 1-index

  -- walk up the tree
  local lang_tree = vim.treesitter.get_parser(bufnr, 'go')
  local tree = lang_tree:parse()[1]
  local root = tree:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  -- walk up the tree
  while node do
    if node:type() == 'call_expression' then
      local selector = node:child(0)
      if selector and selector:type() == 'selector_expression' then
        local field = selector:field('field')[1]
        if field and vim.treesitter.get_node_text(field, bufnr) == 'Run' then
          local args = node:field 'arguments'
          if args and args[1] then
            local test_name = vim.treesitter.get_node_text(args[1], bufnr)

            test_name = test_name:gsub('["\']', '')
            return {
              name = test_name,
              node = node,
            }
          end
        end
      end
    end

    node = node:parent()
  end

  return nil
end

function M.get_test_at_cursor()
  local func_node = M.get_function_at_cursor()
  if not func_node then
    return nil, nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local func_name = vim.treesitter.get_node_text(func_node:field('name')[1], bufnr)

  if not func_name:match '^Test' then
    return nil, nil
  end

  local subtests = M.get_subtest_at_cursor()

  return {
    name = func_name,
    node = func_node,
  }, subtests
end

return M
