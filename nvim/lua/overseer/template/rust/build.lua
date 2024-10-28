local cfg = {
  name = 'Cargo Build',
  builder = function(params)
    return {
      cmd = { 'cargo', 'build' },
    }
  end,
  condition = {
    filetype = { 'rust' },
  },
}

return cfg
