local ts_utils = require 'nvim-treesitter.ts_utils'
local ts_locals = require 'nvim-treesitter.locals'
local ts_query = require 'nvim-treesitter.query'
local parsers = require 'nvim-treesitter.parsers'
local api = vim.api
local fn = vim.fn
local get_node_text = vim.treesitter.get_node_text
local parse = vim.treesitter.query.parse
local nodes = {}
local nodestime = {}

local M = {
  query_package = '(package_clause (package_identifier)@package.name)@package.clause',
  query_struct = '(type_spec name:(type_identifier) @definition.struct type: (struct_type))',
  query_func = '((function_declaration name: (identifier)@function.name) @function.declaration)',
  query_method = '(method_declaration receiver: (parameter_list (parameter_declaration name:(identifier)@method.receiver.name type:(type_identifier)@method.receiver.type)) name:(field_identifier)@method.name)@method.declaration',
  query_method_name = [[((method_declaration
     receiver: (parameter_list)@method.receiver
     name: (field_identifier)@method.name
     body:(block))@method.declaration)]],
  query_test_func = [[((function_declaration name: (identifier) @test_name
        parameters: (parameter_list
            (parameter_declaration
                     name: (identifier)
                     type: (pointer_type
                         (qualified_type
                          package: (package_identifier) @_param_package
                          name: (type_identifier) @_param_name))))
         ) @testfunc
      (#contains? @test_name "Test"))]],
  query_tbl_testcase_node = [[ ( literal_value (
      literal_element (
        literal_value .(
          keyed_element
            (literal_element (identifier))
            (literal_element (interpreted_string_literal) @test.name)
         )
       ) @test.block
    ))
  ]],
  query_sub_testcase_node = [[ (call_expression
    (selector_expression
      (field_identifier) @method.name)
    (argument_list
      (interpreted_string_literal) @tc.name
      (func_literal) )
    (#eq? @method.name "Run")
  ) @tc.run ]],
}

M.get_all_nodes = function(query, lang, defaults, bufnr, pos_row, pos_col, ntype)
  bufnr = bufnr or api.nvim_get_current_buf()
  local key = tostring(bufnr) .. query
  local filetime = fn.getftime(fn.expand '%')
  if nodes[key] ~= nil and nodestime[key] ~= nil and filetime == nodestime[key] then
    return nodes[key]
  end
  if lang ~= 'go' then
    return nil
  end

  pos_row = pos_row or 30000
  local success, parsed_query = pcall(function()
    return parse(lang, query)
  end)
  if not success then
    return nil
  end

  local parser = parsers.get_parser(bufnr, lang)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  local results = {}
  local node_type

  for match in ts_query.iter_prepared_matches(parsed_query, root, bufnr, start_row, end_row) do
    local sRow, sCol, eRow, eCol
    local declaration_node
    local type_node
    local type = ''
    local name = ''
    local op = ''

    ts_locals.recurse_local_nodes(match, function(_, node, path)
      -- local idx = string.find(path, ".", 1, true)
      -- The query may return multiple nodes, e.g.
      -- (type_declaration (type_spec name:(type_identifier)@type_decl.name type:(type_identifier)@type_decl.type))@type_decl.declaration
      -- returns { { @type_decl.name, @type_decl.type, @type_decl.declaration} ... }
      local idx = string.find(path, '.[^.]*$') -- find last `.`
      op = string.sub(path, idx + 1, #path)
      local a1, b1, c1, d1 = vim.treesitter.get_node_range(node)
      local dbg_txt = get_node_text(node, bufnr) or ''
      if #dbg_txt > 100 then
        dbg_txt = string.sub(dbg_txt, 1, 100) .. '...'
      end
      type = string.sub(path, 1, idx - 1) -- e.g. struct.name, type is struct
      if type:find 'type' and op == 'type' then -- type_declaration.type
        node_type = get_node_text(node, bufnr)
        ulog('type: ' .. type)
      end

      -- stylua: ignore end
      --
      -- may not handle complex node
      if op == 'name' or op == 'value' or op == 'definition' then
        name = get_node_text(node, bufnr) or ''
        type_node = node
      elseif op == 'declaration' or op == 'clause' then
        declaration_node = node
        sRow, sCol, eRow, eCol = ts_utils.get_vim_range({ vim.treesitter.get_node_range(node) }, bufnr)
      end
    end)
    if declaration_node ~= nil then
      table.insert(results, {
        declaring_node = declaration_node,
        dim = { s = { r = sRow, c = sCol }, e = { r = eRow, c = eCol } },
        name = name,
        operator = op,
        type = node_type or type,
      })
    end
    if type_node ~= nil and ntype then
      sRow, sCol, eRow, eCol = ts_utils.get_vim_range({ vim.treesitter.get_node_range(type_node) }, bufnr)
      table.insert(results, {
        type_node = type_node,
        dim = { s = { r = sRow, c = sCol }, e = { r = eRow, c = eCol } },
        name = name,
        operator = op,
        type = type,
      })
    end
  end

  nodes[key] = results
  nodestime[key] = filetime
  return results
end

M.nodes_at_cursor = function(query, default, bufnr, ntype)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row, col = row, col + 1
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'ft')
  if ft ~= 'go' then
    return
  end
  local ns = M.get_all_nodes(query, ft, default, bufnr, row, col, ntype)
  if ns == nil then
    vim.notify('Unable to find any nodes. place your cursor on a go symbol and try again', vim.log.levels.DEBUG)
    return nil
  end
  local nodes_at_cursor = M.sort_nodes(M.intersect_nodes(ns, row, col))
  if not nodes_at_cursor then
    -- cmp-command-line will causing cursor to move to end of line
    -- lets try move back a bit and try to find nodes again
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row, col = row, col - 5
    nodes_at_cursor = M.sort_nodes(M.intersect_nodes(ns, row, col))
  end
  if nodes_at_cursor == nil or #nodes_at_cursor == 0 then
    return nil
  end

  return nodes_at_cursor
end

return M
