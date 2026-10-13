local opts = { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  commit = 'a4ed82509cecc56df1c7138920a1aeaf246c0ac5',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'ibhagwan/fzf-lua', commit = '6995a3f8ba256a7a9949747ffbdf5a88eb8a3697' },
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
    local fzf = require 'fzf-lua'

    fzf.setup {
      'telescope',
      files = {
        cmd = "rg --files --hidden --no-ignore-vcs --glob '!**/.git/*' --glob '!**/node_modules/*'",
      },
      grep = {
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --hidden --trim' .. " --glob '!**/.git/*' --glob '!**/node_modules/*' -e",
        actions = {
          ['ctrl-f'] = { require('fzf-lua.actions').grep_lgrep },
        },
      },
    }

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
            '--no-ignore-vcs',
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
        file_browser = {
          hidden = true,
        },
        fzf = {},
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'live_grep_args')
    pcall(telescope.load_extension, 'fidget')

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = desc })
    end

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local git_diff = require 'utils.diff_picker'

    -- Search through git status and find changes on a per file basis
    map('<leader>gsd', git_diff.git_status_difftastic_picker, 'Diff current changes')
    map('<leader>gsb', git_diff.git_diff_parent_picker, 'Diff parent with current branch')

    -- Search through git commits for a select range of lines in a buffer
    vim.keymap.set({ 'n', 'x' }, '<leader>gsh', function()
      if vim.fn.mode():find '[vV\22]' then
        fzf.git_bcommits()
        return
      end
      local line = vim.fn.line '.'
      local cmd = fzf.config.globals.git.bcommits.cmd:gsub('%s+%-%-%s+[<{]file[}>]', ' {file}')
      cmd = cmd:gsub('[<{]file[}>]', string.format('-L %d,%d:{file} --no-patch', line, line))
      fzf.git_bcommits { cmd = cmd }
    end, { desc = 'Commit history in the current buffer range.' })

    map('<leader>gsf', function()
      fzf.git_bcommits { follow = true }
    end, 'Commit history for the current file')

    -- Search through git commits and diff results
    map('<leader>gsc', function()
      fzf.git_commits {
        actions = {
          ['ctrl-r'] = function(selected, opts)
            if not selected[1] then
              return
            end
            local hash = fzf.utils.strip_ansi_coloring(selected[1]):match '^%s*(%x+)%s'
            if not hash then
              vim.notify('Could not read the selected commit', vim.log.levels.ERROR)
              return
            end
            vim.ui.select({ 'soft', 'mixed', 'hard' }, { prompt = 'Reset to ' .. hash .. ':' }, function(mode)
              if not mode or vim.fn.confirm('Reset to ' .. hash .. ' (' .. mode .. ')?', '&Reset\n&Cancel', 2) ~= 1 then
                return
              end
              local cmd = require('fzf-lua.path').git_cwd({ 'git', 'reset', '--' .. mode, hash }, opts)
              local result = vim.system(cmd, { cwd = opts.cwd, text = true }):wait()
              if result.code == 0 then
                vim.notify('Reset to ' .. hash .. ' (' .. mode .. ')', vim.log.levels.INFO)
              else
                local message = vim.trim(result.stderr or '')
                if message == '' then
                  message = vim.trim(result.stdout or '')
                end
                vim.notify(message ~= '' and message or 'Git reset failed', vim.log.levels.ERROR)
              end
            end)
          end,
        },
      }
    end, 'Commits. <c-r> = reset menu')

    -- Search through git stash and find changes on a per file basis
    map('<leader>gss', fzf.git_stash, '[S]tash items. Apply with <cr>')
    map('<leader>sh', fzf.search_history, '[S]earch [H]istory')
    map('<leader>st', fzf.helptags, '[S]earch Help [T]ags')
    map('<leader>sk', fzf.keymaps, '[S]earch [K]eymaps')
    map('<leader>sf', fzf.files, '[S]earch [F]iles')
    map('<leader>ss', fzf.builtin, '[S]earch [S]elect Picker')
    map('<leader>sw', function()
      fzf.grep { search = vim.fn.expand '<cword>' }
    end, '[S]earch current [W]ord')
    map('<leader>sg', fzf.live_grep, '[S]earch by [G]rep')
    map('<leader>sd', fzf.diagnostics_workspace, '[S]earch [D]iagnostics')
    map('<leader>sr', fzf.resume, '[S]earch [R]esume')
    map('<leader>sR', builtin.resume, 'Resume Telescope')
    map('<leader>s.', function()
      fzf.oldfiles {
        cwd_only = true,
      }
    end, '[S]earch Recent Files ("." for repeat)')
    map('<leader>sz', fzf.spell_suggest, '[S]pelling Suggestions')
    map('<leader>sqh', fzf.quickfix_stack, '[H]istory')
    map('<leader>sqo', fzf.quickfix, '[O]pen quickfix list')
    map('<leader>sql', fzf.loclist, 'View locList')
    map('<leader>sch', fzf.command_history, '[H]istory')
    map('<leader>sco', fzf.commands, '[O]pen')
    map('<leader>s<leader>', fzf.buffers, '[ ] Find existing buffers')
    map('<leader>sl', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", '[S]earch by Live Grep')

    map('<leader>sb', function()
      fzf.blines { winopts = { preview = { hidden = true } } }
    end, '[/] Fuzzily search in current buffer')

    map('<leader>s/', function()
      local files = {}
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(bufnr)
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted and vim.fn.filereadable(name) == 1 then
          files[#files + 1] = name
        end
      end
      if #files == 0 then
        vim.notify('No open files to search', vim.log.levels.INFO)
        return
      end
      fzf.live_grep {
        search_paths = files,
        prompt = 'Live Grep in Open Files> ',
      }
    end, '[S]earch [/] in Open Files')

    -- Shortcut for searching your Neovim configuration files
    map('<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, '[S]earch [N]eovim files')
  end,
}

return opts
