local opts = {
  'toppair/peek.nvim',
  commit = '5820d937d5414baea5f586dc2a3d912a74636e5b',
  event = { 'VeryLazy' },
  build = 'deno task --quiet build:fast',
  config = function()
    local peek = require 'peek'
    peek.setup()
    vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
    vim.api.nvim_create_user_command('PeekClose', peek.close, {})

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(args)
        vim.keymap.set('n', '<leader>bov', function()
          if not peek.is_open() then
            vim.fn.system 'i3-msg split horizontal'
            peek.open()
          else
            peek.close()
            vim.fn.system 'i3-msg move left'
          end
        end, {
          buffer = args.buf,
          desc = 'Toggle view markdown',
        })
      end,
    })
  end,
}

return opts
