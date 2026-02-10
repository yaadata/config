local opts = { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  commit = 'a4ed82509cecc56df1c7138920a1aeaf246c0ac5',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = '^1.0.0',
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!
    --- trouble

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require 'telescope.actions'
    -- local open_with_trouble = require('trouble.sources.telescope').open -- Use this to add more results without clearing the trouble list
    -- local add_to_trouble = require('trouble.sources.telescope').add
    local telescope = require 'telescope'

    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      pickers = {
        find_files = {
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--glob',
            '!**/.git/*',
            '--glob',
            '!**/node_modules/*',
          },
        },
        grep_string = {
          additional_args = { '--hidden' },
        },
        live_grep = {
          additional_args = { '--hidden' },
        },
      },
      defaults = {
        mappings = {
          i = {
            ['<C-q>'] = function(bufn)
              actions.smart_send_to_qflist(bufn, '')
              vim.api.nvim_command 'copen'
            end,
            ['<C-f>'] = actions.to_fuzzy_refine,
          },
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--hidden',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--trim',
          '--glob',
          '!**/.git/*',
          '--glob',
          '!**/node_modules/*',
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        file_browser = {
          hidden = true,
        },
        fzf = {},
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'live_grep_args')
    pcall(telescope.load_extension, 'fidget')

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = desc })
    end

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local git_diff = require 'utils.diff_picker'

    -- Search through git status and find changes on a per file basis
    map('<leader>gsc', git_diff.git_status_difftastic_picker, 'Diff current changes')
    map('<leader>gsb', git_diff.git_diff_parent_picker, 'Diff parent with current branch')

    -- Search through git commits for a select range of lines in a buffer
    map('<leader>gsh', builtin.git_bcommits_range, 'Commit history in the current buffer range.')

    map('<leader>gsf', builtin.git_bcommits, 'Commit history for the current file')

    -- Search through git commits and diff results
    map('<leader>gsc', builtin.git_commits, 'Commits. <c-r>s = soft reset, <c-r>h = hard reset, <c-r>m = mixed reset')

    -- Search through git stash and find changes on a per file basis
    map('<leader>gss', builtin.git_stash, '[S]tash items. Apply with <cr>')
    map('<leader>sh', builtin.search_history, '[S]earch [H]istory')
    map('<leader>st', builtin.help_tags, '[S]earch Help [T]ags')
    map('<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
    map('<leader>sf', builtin.find_files, '[S]earch [F]iles')
    map('<leader>ss', builtin.builtin, '[S]earch [S]elect Telescope')
    map('<leader>sw', builtin.grep_string, '[S]earch current [W]ord')
    map('<leader>sg', builtin.live_grep, '[S]earch by [G]rep')
    map('<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics')
    map('<leader>sr', builtin.resume, '[S]earch [R]esume')
    map('<leader>s.', function()
      builtin.oldfiles {
        cwd_only = true,
      }
    end, '[S]earch Recent Files ("." for repeat)')
    map('<leader>sz', builtin.spell_suggest, '[S]pelling Suggestions')
    map('<leader>sqh', builtin.quickfixhistory, '[H]istory')
    map('<leader>sqo', builtin.quickfix, '[O]pen quickfix list')
    map('<leader>sql', builtin.loclist, 'View locList')
    map('<leader>sch', builtin.command_history, '[H]istory')
    map('<leader>sco', builtin.commands, '[O]pen')
    map('<leader>s<leader>', builtin.buffers, '[ ] Find existing buffers')
    map('<leader>sl', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", '[S]earch by Live Grep')

    -- Slightly advanced example of overriding default behavior and theme
    map('<leader>sC', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 0,
        previewer = false,
      })
    end, '[/] Fuzzily search in current buffer')

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    map('<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, '[S]earch [/] in Open Files')

    -- Shortcut for searching your Neovim configuration files
    map('<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, '[S]earch [N]eovim files')

    require('telescope').load_extension 'ui-select'
  end,
}

return opts
