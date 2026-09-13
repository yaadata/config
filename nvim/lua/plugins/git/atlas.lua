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
