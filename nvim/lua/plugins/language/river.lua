return {
  'mutlab-app/vim-river-syntax',
  commit = '3b48e7a5880569f3872635b6ec59562457018dc8',
  ft = { 'river', 'alloy', 'rvr' },
  init = function()
    vim.filetype.add {
      extension = {
        river = 'river',
        rvr = 'river',
        alloy = 'river',
      },
    }
  end,
}
