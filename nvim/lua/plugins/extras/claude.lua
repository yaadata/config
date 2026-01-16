local toggle_key = '<C-c>'
local opts = {
  'yaadata/claudecode.nvim',
  dependencies = {
    {
      'folke/snacks.nvim',
      tag = 'v2.30.0',
    },
  },
  commit = 'cf1641c788def5e44c497e48dc7b9e63aeac95f1',
  opts = {
    terminal = {
      snacks_win_opts = {
        position = 'float',
        width = 0.9,
        height = 0.9,
        border = 'rounded',
        keys = {
          claude_hide = {
            toggle_key,
            function(self)
              self:hide()
            end,
            mode = 't',
            desc = 'Hide',
          },
        },
      },
      provider = 'snacks',
    },
  },
  keys = {
    { toggle_key, '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude Code', mode = { 'n', 'x' } },
    { '<leader>at', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>ac', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>aS',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

return opts
