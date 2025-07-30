local opts = {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      search = {
        enabled = true,
      },
      char = {
        keys = { 'f', 'F', 't', 'T', ']', '[' },
        jump_labels = true,
        char_actions = function(motion)
          return {
            [']'] = 'next', -- set to `right` to always go right
            ['['] = 'prev', -- set to `left` to always go left
            -- clever-f style
            [motion:lower()] = 'next',
            [motion:upper()] = 'prev',
            -- jump2d style: same case goes next, opposite case goes prev
            -- [motion] = "next",
            -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
          }
        end,
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
}

return opts
