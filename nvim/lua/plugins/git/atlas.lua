---@module 'atlas'

return {
  'yaadata/atlas.nvim',
  branch = 'next',
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
    },
    keymaps = {
      ui = {
        comments = {
          add = '<leader>ca',
          reply = '<leader>cr',
          edit = '<leader>ce',
          react = '<leader>cR',
        },
      },
      pulls = {
        review = {
          approve = '<leader>ra',
          request_changes = '<leader>rb', -- block on request changes
          submit_review = '<leader>rs',
          add_task = '<leader>rt',
          comment_templates = '<leader>rC',
          diff = {
            add_comment = '<leader>rca',
            submit_comment = '<leader>rcs',
            add_suggestion = '<leader>rsa', -- change
            submit_suggestion = '<leader>rss',
            add_note = '<leader>rna',
            toggle_resolved = '<leader>rx',
          },
        },
      },
      issues = {
        transition_issue = '<leader>it',
        change_assignee = '<leader>ia',
        change_reporter = '<leader>ir',
        edit_issue = '<leader>ie',
        create_issue = '<leader>ic',
      },
    },
  },
}
