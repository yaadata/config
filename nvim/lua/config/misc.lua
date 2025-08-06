-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Language and tools
-- golang
vim.g.go_build_tags = 'integration,test,unit,endtoendtest,smoke'
vim.g.go_gopls_options = { '-remote=auto' }
vim.g.go_fmt_autosave = 0
vim.g.go_imports_autosave = 0
vim.g.go_gopls_enabled = 0

-- diagnostics
vim.diagnostic.config { virtual_text = true }

-- neovide
vim.opt.exrc = true
-- claude
vim.env.CLAUDE_CONFIG_DIR = vim.fn.expand '~/.config/claude'

-- filetype
vim.filetype.add {
  extension = {
    sy = 'starlark',
  },
}
