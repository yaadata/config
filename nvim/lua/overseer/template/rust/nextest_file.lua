local cfg = {
  name = 'Cargo (Nex)Test File',
  builder = function(params)
    local uts = require 'utils.rust_utils'
    local fn = uts.get_test_name()
    return {
      cmd = { 'cargo', 'nextest', 'run', '--', fn },
    }
  end,
  condition = {
    filetype = { 'rust' },
  },
}

return cfg
