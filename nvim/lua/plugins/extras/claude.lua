local toggle_key = '<C-c>'
local opts = {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  commit = '985b4b117ea13ec85c92830ecac8f63543dd5ead',
  opts = {
    terminal = {
      snacks_win_opts = {
        position = 'float',
        width = 0.9,
        height = 0.9,
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
    { '<leader>ct', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>cc', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>cS',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

return opts
