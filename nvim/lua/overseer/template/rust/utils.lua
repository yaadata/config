local uts = {}

function uts.get_test_name()
  -- Get the node under cursor
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- Convert to 0-based index

  local parser = vim.treesitter.get_parser(0, 'rust')
  local tree = parser:parse()
  local root = tree[1]:root()

  -- Get node at cursor
  local node = root:named_descendant_for_range(row, col, row, col)
  if not node then
    return nil
  end

  -- Walk up the tree to find the containing function
  while node do
    if node:type() == 'function_item' then
      -- Check previous siblings for the test attribute
      local sibling = node:prev_named_sibling()
      while sibling do
        if sibling:type() == 'attribute_item' then
          local attr_text = vim.treesitter.get_node_text(sibling, 0)
          if attr_text:match '#%[tokio::test%]' or attr_text:match '#%[test%]' then
            -- Found a test function, get its name
            for child in node:iter_children() do
              if child:type() == 'identifier' then
                return vim.treesitter.get_node_text(child, 0)
              end
            end
          end
        end
        sibling = sibling:prev_named_sibling()
      end
    end
    node = node:parent()
  end
  return nil
end

return uts
