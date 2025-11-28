local opts = {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  commit = 'a4e3c15dfdce8783c074539b1835edae75fa63d5',
  opts = {
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    hint_prefix = '💡 ', -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
    floating_window = true,
    floating_window_above_cur_line = true,
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
    vim.keymap.set({ 'n' }, '<Leader>ltk', function()
      vim.lsp.buf.signature_help()
    end, { silent = true, noremap = true, desc = 'toggle signature' })
  end,
}

return opts
