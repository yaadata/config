---@module 'atlas'

local opts = {
  'emrearmagan/atlas.nvim',
  tag = '0.7.12',
  dependencies = {
    'MeanderingProgrammer/render-markdown.nvim', -- optional but recommended
    'esmuellert/codediff.nvim', -- optional (PullRequest diff)
  },
  keys = {
    { '<leader>apg', '<cmd>Atlas pulls github<cr>', desc = 'Atlas GitHub Pulls' },
  },
  ---@type AtlasConfig
  opts = {
    providers = {
      github = {
        token = vim.env.GITHUB_TOKEN,
      },
    },
    pulls = {
      github = {
        views = {
          {
            name = 'Authored',
            key = '1',
            layout = 'compact',
            search = 'is:pr is:open author:@me archived:false sort:updated-desc',
          },
          {
            name = 'Assigned',
            key = '2',
            layout = 'compact',
            search = 'is:pr is:open assignee:@me draft:false archived:false sort:updated-desc',
          },
          {
            name = 'Needs Review',
            key = '3',
            layout = 'compact',
            search = 'is:pr is:open review-requested:@me draft:false archived:false sort:updated-desc',
          },
        },
      },
      forgejo = {
        views = {
          {
            name = 'Authored',
            key = '1',
            layout = 'compact',
            search = 'is:open',
            extra_params = { created = true, sort = 'recentupdate' },
          },
          {
            name = 'Assigned',
            key = '2',
            layout = 'compact',
            search = 'is:open',
            extra_params = { assigned = true, sort = 'recentupdate' },
          },
          {
            name = 'Needs Review',
            key = '3',
            layout = 'compact',
            search = 'is:open',
            extra_params = { review_requested = true, sort = 'recentupdate' },
          },
        },
      },
      diff = {
        open_cmd = 'CodeDiff',
      },
    },
    keymaps = {
      ui = {
        help = 'g?', -- { "g?", "<leader>?" } would add aliases
        close = 'q', -- false would disable it
        next_item = 'j',
        previous_item = 'k',
        first_item = 'gg',
        last_item = 'G',
        select = '<CR>',
        submit = '<C-s>',
        delete = 'dd',
        comments = {
          add = '<leader>ca',
          reply = '<leader>cr',
          edit = '<leader>ce',
          react = '<leader>cR',
        },
        toggle_panel = 'p',
        toggle_fold = 'za',
        toggle_all_folds = 'zA',
        previous_panel_tab = '<S-Tab>',
        next_panel_tab = '<Tab>',
        notifications = {
          open = 'N',
          mark_read = 'r',
          mark_done = 'd',
        },
        toggle_subscription = 'gS',
        toggle_star = '*',
        refresh = 'r',
        refresh_view = 'R',
        next_page = ']p',
        previous_page = '[p',
        open_actions = 'A',
        open_in_browser = 'gx',
        copy_id = 'y',
        copy_url = 'Y',
        show_details = 'K',
        search = '?',
      },
      picker = {
        next_item = { '<Down>', '<C-n>', '<C-j>' },
        previous_item = { '<Up>', '<C-p>', '<C-k>' },
        select = { '<CR>', '<C-s>' },
        toggle = '<Tab>',
        close = { 'q', '<Esc>' },
      },
      pulls = {
        review = {
          open_diff = '<leader>gdo',
          checkout = '<leader>gdc',
          external_help = '<leader>g?', -- Atlas help in external diff viewers
          toggle_repo_panel = '<leader>grp',
          toggle_repo_issue_state = '<leader>gri',
          edit_title = '<leader>get',
          edit_description = '<leader>ged',
          edit_search = '<leader>ges',
          focus_item = '<leader>gf',
          approve = '<leader>gra',
          request_changes = '<leader>grd', -- block on request changes
          submit_review = '<leader>grc',
          add_task = '<leader>grt',
          comment_templates = '<leader>grc',
          diff = {
            lsp = {
              enabled = true,
            },
            add_comment = '<leader>gce',
            submit_comment = '<leader>gca',
            add_suggestion = '<leader>gse', -- change
            submit_suggestion = '<leader>gsa',
            add_note = '<leader>gna',
            toggle_resolved = '<leader>gcT',

            toggle_layout = '<leader>glt',
            toggle_compact = '<leader>glc',
            next_hunk = ']c',
            previous_hunk = '[c',
            toggle_review_panel = '<leader>gpr',
            toggle_detail_panel = '<leader>gpd',
            toggle_comments = '<leader>gct',
            next_comment = ']C',
            previous_comment = '[C',
            next_note = ']n',
            previous_note = '[n',
          },
        },
        filters = {
          open = '<leader>fo',
          merged = '<leader>fm',
          declined = '<leader>fd',
        },
      },
      issues = {
        transition_issue = '<leader>ics',
        change_assignee = '<leader>ica',
        change_reporter = '<leader>icr',
        edit_issue = '<leader>ice',
        create_issue = '<leader>ia',
        edit_search = '<leader>ie',
        toggle_description_mode = '<leader>itd',
      },
    },
  },
}

return opts
