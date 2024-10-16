local opts = {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  opts = {
    hint_prefix = {
      above = '↙ ', -- when the hint is on the line above the current line
      current = '← ', -- when the hint is on the same line
      below = '↖ ', -- when the hint is on the line below the current line
    },
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}

return opts
