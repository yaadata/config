---@module 'atlas'

local opts = {
  'yaadata/atlas.nvim',
  branch = 'next',
  keys = {
    { '<leader>apg', '<cmd>Atlas pulls github<cr>', desc = 'Atlas GitHub Pulls' },
    { '<leader>aij', '<cmd>Atlas issues jira<cr>', desc = 'Atlas Jira Issues' },
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
        comments = {
          add = '<leader>aca',
          reply = '<leader>acr',
          edit = '<leader>ace',
          react = '<leader>acR',
        },
      },
      pulls = {
        review = {
          approve = '<leader>ara',
          request_changes = '<leader>arb', -- block on request changes
          submit_review = '<leader>ars',
          add_task = '<leader>art',
          comment_templates = '<leader>arC',
          diff = {
            add_comment = '<leader>arca',
            submit_comment = '<leader>arcs',
            add_suggestion = '<leader>arsa', -- change
            submit_suggestion = '<leader>arss',
            add_note = '<leader>arn',
            toggle_resolved = '<leader>arx',
          },
        },
      },
      issues = {
        transition_issue = '<leader>ait',
        change_assignee = '<leader>aia',
        change_reporter = '<leader>air',
        edit_issue = '<leader>aie',
        create_issue = '<leader>aic',
      },
    },
  },
}

return opts
