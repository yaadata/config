---@module 'atlas'

local opts = {
  'yaadata/atlas.nvim',
  branch = 'next',
  keys = {
    { '<leader>wap', '<cmd>Atlas pulls github<cr>', desc = 'Atlas GitHub Pulls' },
    { '<leader>wai', '<cmd>Atlas issues jira<cr>', desc = 'Atlas Jira Issues' },
  },
  ---@type AtlasConfig
  opts = {
    providers = {
      github = {
        token = vim.env.GITHUB_TOKEN,
      },
      ---@type AtlasJiraConfig
      jira = {
        base_url = 'https://mux1.atlassian.net',
        email = vim.env.ATLASSIAN_USER,
        --- See: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
        token = vim.env.ATLASSIAN_TOKEN,
        auth_method = 'basic',
        api_type = 'cloud',
        cache_ttl = 300,
      },
    },
    pulls = {
      github = {
        views = {
          {
            name = 'Needs Review',
            key = '1',
            layout = 'compact',
            search = ('org:%s is:pr is:open review-requested:@me draft:false archived:false sort:updated-desc'):format(vim.env.GITHUB_ORG),
          },
          {
            name = 'Authored',
            key = '2',
            layout = 'compact',
            search = ('org:%s is:pr is:open author:@me archived:false sort:updated-desc'):format(vim.env.GITHUB_ORG),
          },
          {
            name = 'Recently Merged',
            key = '3',
            layout = 'compact',
            search = ('org:%s is:pr author:@me is:merged archived:false sort:updated-desc'):format(vim.env.GITHUB_ORG),
          },
          {
            name = 'Assigned',
            key = '4',
            layout = 'compact',
            search = ('org:%s is:pr is:open assignee:@me draft:false archived:false sort:updated-desc'):format(vim.env.GITHUB_ORG),
          },
        },
      },
      diff = {
        open_cmd = 'CodeDiff',
      },
    },
    issues = {
      jira = {
        views = {
          {
            name = 'My Current Sprint',
            key = '1',
            layout = 'compact',
            jql = 'sprint in openSprints() AND assignee = currentUser() ORDER BY status ASC',
          },
          {
            name = 'Current Sprint',
            key = '2',
            layout = 'compact',
            jql = 'project = DATA AND sprint in openSprints() ORDER BY assignee ASC, status ASC',
          },
          {
            name = 'Current Epics',
            key = '3',
            layout = 'compact',
            jql = 'project = DATA AND issuetype = Epic AND statusCategory != Done AND status != Backlog ORDER BY status ASC, assignee ASC',
          },
        },
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
          react = '<leader>ci',
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
        open_diff = '<leader>gd',
        checkout = '<leader>gc',
        external_help = '<leader>gA', -- Atlas help in external diff viewers
        toggle_repo_panel = '<leader>rtp',
        toggle_repo_issue_state = '<leader>rti',
        edit_title = 'T',
        edit_description = 'D',
        edit_search = 'i',
        review = {
          focus_item = '<leader>rf',
          approve = '<leader>ra',
          request_changes = '<leader>rS', -- block on request changes
          submit_review = '<leader>rr',
          add_task = '<leader>rT',
          comment_templates = '<leader>rC',
          diff = {
            add_comment = '<leader>rca',
            submit_comment = '<leader>rcs',
            add_suggestion = '<leader>rsa', -- change
            submit_suggestion = '<leader>rss',
            add_note = '<leader>rn',
            toggle_resolved = '<leader>rtr',

            toggle_layout = '<leader>rtl',
            toggle_compact = '<leader>rtC',
            next_hunk = ']h',
            previous_hunk = '[h',
            toggle_review_panel = '<leader>rtR',
            toggle_detail_panel = '<leader>rtD',
            toggle_comments = '<leader>rtc',
            next_comment = ']c',
            previous_comment = '[c',
            next_note = ']n',
            previous_note = '[n',
          },
        },
        filters = {
          open = '<leader>rfo',
          merged = '<leader>rfm',
          declined = '<leader>rfd',
        },
      },
      issues = {
        transition_issue = '<leader>ics',
        change_assignee = '<leader>ica',
        change_reporter = '<leader>icr',
        edit_issue = '<leader>ie',
        create_issue = '<leader>in',
        edit_search = '<leader>si',
        toggle_description_mode = '<leader>itm',
      },
    },
  },
}

return opts
