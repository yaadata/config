local cfg = {
  name = 'Cargo (Nex)Test Function',
  builder = function(_)
    local uts = require 'overseer.template.rust.utils'
    local fn = uts.get_test_name()
    local cmd = { 'cargo', 'nextest', 'run', '--', fn }
    if fn == nil then
      vim.notify('no test found', 4)
      cmd = { 'echo', '"no test found"' }
    end
    return {
      cmd = cmd,
    }
  end,
  condition = {
    filetype = { 'rust' },
    callback = function(_)
      local uts = require 'overseer.template.rust.utils'
      local fn = uts.get_test_name()
      return fn ~= nil
    end,
  },
}

return cfg
