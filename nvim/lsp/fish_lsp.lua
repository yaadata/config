return {
  root_dir = function(_, on_dir)
    on_dir(vim.fn.getcwd())
  end,
  root_markers = { 'config.fish' },
}
