---@module 'atlas'

local opts = {
  'yaadata/atlas.nvim',
  branch = 'next',
  keys = {
    { '<leader>apg', '<cmd>Atlas pulls github<cr>', desc = 'Atlas GitHub Pulls' },
  },
  ---@type AtlasConfig
  opts = {
    providers = {
      github = {
        token = vim.env.GITHUB_TOKEN,
      },
      forgejo = {
        base_url = 'https://codeberg.org',
        token = vim.env.FORGEJO_TOKEN,
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
          add = 'aca',
          reply = 'acr',
          edit = 'ace',
          react = 'acR',
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
          open_diff = 'gd',
          checkout = 'gc',
          external_help = 'gA', -- Atlas help in external diff viewers
          toggle_repo_panel = 'o',
          toggle_repo_issue_state = 't',
          edit_title = 'T',
          edit_description = 'D',
          edit_search = 'i',
          focus_item = 'rf',
          approve = 'ra',
          request_changes = 'rS', -- block on request changes
          submit_review = 'rr',
          add_task = 'rt',
          comment_templates = 'rC',
          diff = {
            add_comment = 'rca',
            submit_comment = 'rcs',
            add_suggestion = 'rsa', -- change
            submit_suggestion = 'rss',
            add_note = 'rn',
            toggle_resolved = 'rX',

            toggle_layout = 't',
            toggle_compact = 'gc',
            next_hunk = ']h',
            previous_hunk = '[h',
            toggle_review_panel = 'gR',
            toggle_detail_panel = 'gD',
            toggle_comments = 'gH',
            next_comment = ']c',
            previous_comment = '[c',
            next_note = ']n',
            previous_note = '[n',
          },
        },
        filters = {
          open = 'gpo',
          merged = 'gpm',
          declined = 'gpd',
        },
      },
      issues = {
        transition_issue = 'gt',
        change_assignee = 'ga',
        change_reporter = 'gr',
        edit_issue = 'ge',
        create_issue = 'gc',
        edit_search = 'i',
        toggle_description_mode = 'm',
      },
    },
  },
}

return opts
