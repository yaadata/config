-- obsidian.nvim renders checkboxes / callouts / bullets with explicit conceal
-- characters, which only show at conceallevel 1 or 2 (conceallevel 3 hides the
-- overlay entirely, 0 shows raw syntax).
-- See https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'
