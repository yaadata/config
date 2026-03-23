local opts = {
  'goolord/alpha-nvim',
  commit = 'a9d8fb72213c8b461e791409e7feabb74eb6ce73',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    local header = {
      type = 'text',
      val = {
        '███╗    ██╗  ████████╗    ███████╗   ██╗     ██╗  ██████╗  ███╗     ███╗',
        '████╗   ██║  ██╔═════╝   ██╔════██╗  ██║     ██║  ╚═██╔═╝  ████╗   ████║',
        '█████╗  ██║  ██║         ██║    ██║  ██║     ██║    ██║    ██╔██╗ ██╔██║',
        '██║ ██╗ ██║  ██████╗     ██║    ██║  ██║     ██║    ██║    ██║ ████╔╝██║',
        '██║  ██╗██║  ██╔═══╝     ██║    ██║   ██╗   ██╗     ██║    ██║  ██╔╝ ██║',
        '██║    ███║  ████████╗   ╚███████╔╝    ╚████╔╝    ██████╗  ██║   ═╝  ██║',
        '╚═╝     ╚═╝  ╚═══════╝    ╚══════╝      ╚═══╝     ╚═════╝  ╚═╝       ╚═╝',
      },
      opts = { position = 'center', hl = 'AlphaHeader' },
    }

    local cwd = {
      type = 'text',
      val = function()
        return '  ' .. vim.fn.getcwd()
      end,
      opts = { position = 'center', hl = 'Comment' },
    }

    local helper = {
      type = 'text',
      val = {
        '--------------------------------------------',
        '',
        'type  :help<Enter>          for help',
        'type  :checkhealth<Enter>   to optimize Nvim',
        'type  :q<Enter>             to exit',
        '',
        '--------------------------------------------',
      },
      opts = { position = 'center', hl = 'Comment' },
    }

    local buttons = {
      type = 'group',
      val = {
        dashboard.button('e', '  New File', '<cmd>ene<CR>'),
        dashboard.button('f', '  Find File', '<cmd>Telescope find_files<CR>'),
        dashboard.button('r', '  Recent Files', '<cmd>Telescope oldfiles cwd_only=true<CR>'),
        dashboard.button('s', '  Session Search', '<cmd>AutoSession search <CR>'),
        dashboard.button('d', '  Session Delete', '<cmd>AutoSession deletePicker <CR>'),
        dashboard.button('g', '  LazyGit', '<cmd>LazyGitToggle<cr>'),
        dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
      },
      opts = { spacing = 1 },
    }

    alpha.setup {
      layout = {
        { type = 'padding', val = 2 },
        header,
        { type = 'padding', val = 1 },
        cwd,
        { type = 'padding', val = 2 },
        buttons,
        { type = 'padding', val = 2 },
        helper,
        { type = 'padding', val = 1 },
      },
      opts = { margin = 5 },
    }
  end,
}

return opts
