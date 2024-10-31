local utils = require 'utils.utensils'
local helper = require 'overseer.template.golang.utils.helper'
_GOTEST_CMD_CFG = {
  build_tags = {},
  verbose = false,
  parallel_count = 1,
  directory = '',
  package = '',
}

M.get_build_tags = function()
  local tags = {}
  if not utils.empty(_GOTEST_CMD_CFG.build_tags) then
    tags = _GOTEST_CMD_CFG.build_tags
  end

  local rt = helper.get_build_tags()
  if not utils.empty(rt) then
    vim.list_extend(tags, rt)
  end

  local t = '-tags'
  if #tags > 0 then
    return t .. '=' .. table.concat(tags, ',')
  end
end

local function get_test_file_bufnr()
  local fn = vim.fn.expand '%'
end

return M
