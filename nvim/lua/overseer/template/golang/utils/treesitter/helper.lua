local go_ts = require 'overseer.template.golang.utils.treesitter.wellknow_structures'

local function get_name_defaults()
  return { ['func'] = 'function', ['if'] = 'if', ['else'] = 'else', ['for'] = 'for' }
end

local M = {}

M.get_table_testcase_node_name = function(bufnr)
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufn, 'go')
  if not parser then
    return warn('treesitter parser not found for' .. vim.fn.bufname(bufn))
  end

  local tree = parser:parse()
  tree = tree[1] -- lua is 1-indexed for libraries

  local tbl_case_query = vim.treesitter.query.parse('go', go_ts.query_tbl_testcase_node)
  local curr_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  for _, match, _ in tbl_case_query:iter_matches(tree:root(), bufn, 0, -1) do
    local tc_name = nil
    for id, node in pairs(match) do
      local name = tbl_case_query.captures[id]
      if name == 'test.name' then
        tc_name = vim.treesitter.get_node_text(node, bufn)
      end

      if name == 'test.block' then
        local start_row, _, end_row, _ = node:range()
        if curr_row >= start_row and curr_row <= end_row then
          return tc_name
        end
      end
    end
  end

  return nil
end

M.get_sub_testcase_name = function(bufnr)
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufn, 'go')
  if not parser then
    return warn('treesitter parser not found for' .. vim.fn.bufname(bufn))
  end

  local tree = parser:parse()
  tree = tree[1] -- lua is 1-indexed for libraries

  local sub_testcase_query = vim.treesitter.query.parse('go', go_ts.query_sub_testcase_node)
  local is_inisde_test = false
  local curr_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  for id, node in sub_testcase_query:iter_matches(tree:root(), bufn, 0, -1) do
    local name = sub_testcase_query.captures[id]
    -- tc_run is the first capture of the mathc, so we can use it to check if we are inside of a test
    if name == 'tc.run' then
      local start_row, _, end_row, _ = node:range()
      if curr_row >= start_row and curr_row <= end_row then
        is_inisde_test = true
      else
        is_inisde_test = false
      end
      goto continue_loop
    end
    if name == 'tc.name' and is_inisde_test then
      return vim.treesitter.get_node_text(node, bufn)
    end
    ::continue_loop::
  end
  return nil
end

M.get_func_method_node_at_pos = function(bufnr)
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local query = go_ts.query_func .. '' .. go_ts.query_method_name
  local ns = go_ts.nodes_at_cursor(query, get_name_defaults(), bufn)
  if ns == nil then
    warn 'function not found'
    return nil
  end
  return ns[#ns]
end

return M
