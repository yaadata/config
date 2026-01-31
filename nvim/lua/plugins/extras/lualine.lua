local opts = {
  'nvim-lualine/lualine.nvim',
  commit = 'e5459241bde5949305b9583bb4eedf322a2a8e7c',
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      enabled = true,
    },
    'cbochs/grapple.nvim',
  },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'palenight',
        globalstatus = false,
      },
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
