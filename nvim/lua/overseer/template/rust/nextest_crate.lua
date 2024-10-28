local cfg = {
  name = 'Cargo (Nex)Test Crate',
  builder = function(params)
    local fs = require 'utils.fs'
    local directory = fs.buffer_directory_name()
    local module_path = string.format('%s::', directory)
    return {
      cmd = { 'cargo', 'nextest', 'run', module_path },
    }
  end,
  condition = {
    filetype = { 'rust' },
  },
}

return cfg
