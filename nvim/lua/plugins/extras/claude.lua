local toggle_key = '<C-c>'
local opts = {
  'yaadata/claudecode.nvim',
  dependencies = {
    {
      'folke/snacks.nvim',
      tag = 'v2.30.0',
    },
  },
  commit = '38203423fb8b64c1446d0e22578ec10c25ccaf88',
  opts = {
    terminal = {
      snacks_win_opts = {
        position = 'left',
        border = 'rounded',
        width = 0.2,
        keys = {
          claude_hide = {
            toggle_key,
            function(self)
              self:hide()
            end,
            mode = 't',
            desc = 'Hide',
          },
          claude_nav_right = {
            '<C-l>',
            function(self)
              if self:is_floating() then
                return
              end
              vim.cmd 'wincmd l'
            end,
            mode = 't',
            desc = 'Move to right buffer',
          },
          claude_nav_left = {
            '<C-h>',
            function(self)
              if self:is_floating() then
                return
              end
              vim.cmd 'wincmd h'
            end,
            mode = 't',
            desc = 'Move to left buffer',
          },
        },
      },
      provider = 'snacks',
    },
  },
  keys = {
    { toggle_key, '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude Code', mode = { 'n', 'x' } },
    { '<leader>aat', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>aaf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>aar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aac', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>aas', '<cmd>ClaudeCodeAdd %<cr>', mode = 'n', desc = 'Add current buffer' },
    { '<leader>aas', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send Selection to Claude' },
    {
      '<leader>aaS',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>aaa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>aad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

return opts
