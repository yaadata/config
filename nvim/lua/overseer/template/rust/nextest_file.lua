local cfg = {
  name = 'Cargo (Nex)Test File',
  builder = function(_)
    local fs = require 'utils.fs'
    local fn = fs.buffer_filename()
    fn = vim.fn.fnamemodify(fn, ':r')
    local module_path = string.format('%s::', fn)
    return {
      cmd = { 'cargo', 'nextest', 'run', module_path },
    }
  end,
  priority = 3,
  condition = {
    filetype = { 'rust' },
  },
}

return cfg
