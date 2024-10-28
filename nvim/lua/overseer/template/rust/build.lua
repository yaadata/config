local cfg = {
  name = 'Cargo Build',
  builder = function(_)
    return {
      cmd = { 'cargo', 'build' },
    }
  end,
  priority = 1,
  condition = {
    filetype = { 'rust' },
  },
}

return cfg
