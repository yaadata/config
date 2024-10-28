local cfg = {
  name = 'Cargo (Nex)Test Function',
  builder = function(_)
    local uts = require 'overseer.template.rust.utils'
    local fn = uts.get_test_name()
    local cmd = { 'cargo', 'nextest', 'run', '--', fn }
    if fn == nil then
      vim.notify('no test found', vim.log.levels.WARN)
      cmd = { 'echo', '"no test found"' }
    end
    return {
      cmd = cmd,
    }
  end,
  priority = 2,
  condition = {
    filetype = { 'rust' },
    callback = function(_)
      local uts = require 'overseer.template.rust.utils'
      local fn = uts.get_test_name()
      local res = true
      if fn == nil then
        res = false
      end
      return res
    end,
  },
}

return cfg
