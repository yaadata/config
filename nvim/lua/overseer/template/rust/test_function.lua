local cfg = {
  name = 'Cargo Test Function',
  builder = function(params)
    local uts = require 'overseer.template.rust.utils'
    local fn = uts.get_test_name()
    cmd = { 'cargo', 'test', fn }
    if fn == nil then
      vim.notify('no test found', 4)
      cmd = { fn }
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
