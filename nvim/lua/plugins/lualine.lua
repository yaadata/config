local opts = {

  'nvim-lualine/lualine.nvim',
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      enabled = true,
    },
    'cbochs/grapple.nvim',
  },
  config = function()
    require('lualine').setup {
      theme = 'palenight',
      sections = {
        lualine_a = { 'branch' },
        lualine_b = {
          {
            function()
              return require('grapple').name_or_index()
            end,
            cond = function()
              return package.loaded['grapple'] and require('grapple').exists()
            end,
          },
        },
        lualine_c = {
          { 'filename', path = 1 },
          'diff',
        },
        lualine_y = { 'location' },
        lualine_z = { 'mode' },
      },
    }
  end,
}

return opts
