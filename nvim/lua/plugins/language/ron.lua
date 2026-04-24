return {
  'ron-rs/ron.vim',
  commit = 'f749e543975a82e8dd9a6e7df9600a1c098ae800',
  ft = { 'ron' },
  init = function()
    vim.filetype.add {
      extension = {
        ron = 'ron',
      },
    }
  end,
}
