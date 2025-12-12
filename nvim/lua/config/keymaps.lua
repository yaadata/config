-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- git
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGitToggle<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gtd', '<cmd>GHDashToggle<cr>', { desc = 'gh dash extension' })

-- window management
vim.keymap.set('n', '<leader>wmsv', '<C-w>v<CR>', { desc = 'split window vertical' })
vim.keymap.set('n', '<leader>wmsh', '<C-w>s<CR>', { desc = 'split window horizontal' })

-- quickfix / location list
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = '[O]pen quickfix' })
vim.keymap.set('n', '<leader>qq', '<cmd>cclose<CR>', { desc = '[C]lose quickfix' })
vim.keymap.set('n', '<leader>qp', '<cmd>cprevious<CR>', { desc = '[P]revious quickfix item' })
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', { desc = '[N]ext quickfix item' })
vim.keymap.set('n', '<leader>qlo', '<cmd>lopen<CR>', { desc = '[O]pen location list' })
vim.keymap.set('n', '<leader>qlx', '<cmd>lclose<CR>', { desc = '[C]lose location list' })
vim.keymap.set('n', '<leader>qlp', '<cmd>lprevious<CR>', { desc = '[P]revious location list' })
vim.keymap.set('n', '<leader>qln', '<cmd>lnext<CR>', { desc = '[N]ext location list' })

-- testing

vim.keymap.set('n', '<leader>bca0', function()
  local text = { 'SCENARIO:   ' }
  local start_line = vim.fn.line '.'
  vim.api.nvim_put(text, 'l', true, true)
  -- Select the inserted lines in visual mode
  local end_line = start_line + #text
  vim.cmd('normal! ' .. start_line + 1 .. 'GV' .. end_line .. 'G')
  -- Trigger the gc command
  vim.cmd 'normal gc'
end, { desc = 'Insert text "Scenario"' })

vim.keymap.set('n', '<leader>bca1', function()
  local text = { '========= [A]rrange =========' }
  local start_line = vim.fn.line '.'
  vim.api.nvim_put(text, 'l', true, true)
  -- Select the inserted lines in visual mode
  local end_line = start_line + #text
  vim.cmd('normal! ' .. start_line + 1 .. 'GV' .. end_line .. 'G')
  -- Trigger the gc command
  vim.cmd 'normal gc'
end, { desc = 'Insert text "arrange"' })

vim.keymap.set('n', '<leader>bca2', function()
  local text = { '========= [A]ct     =========' }
  local start_line = vim.fn.line '.'
  vim.api.nvim_put(text, 'l', true, true)
  -- Select the inserted lines in visual mode
  local end_line = start_line + #text
  vim.cmd('normal! ' .. start_line + 1 .. 'GV' .. end_line .. 'G')
  -- Trigger the gc command
  vim.cmd 'normal gc'
end, { desc = 'Insert text "act"' })

vim.keymap.set('n', '<leader>bca3', function()
  local text = { '========= [A]ssert  =========' }
  local start_line = vim.fn.line '.'
  vim.api.nvim_put(text, 'l', true, true)
  -- Select the inserted lines in visual mode
  local end_line = start_line + #text
  vim.cmd('normal! ' .. start_line + 1 .. 'GV' .. end_line .. 'G')
  -- Trigger the gc command
  vim.cmd 'normal gc'
end, { desc = 'Insert text "assert"' })

-- navigating buffers
vim.keymap.set('n', '<leader>bt', '<cmd>:tabnew<CR>', { desc = 'new [t]ab' })
vim.keymap.set('n', '<leader>br', '<cmd>:e!<CR>', { desc = '[r]efresh' })
vim.keymap.set('n', '<leader>bd', "<cmd>echo expand('% p')<CR>", { desc = 'view [d]irectory path' })
vim.keymap.set('n', '<leader>bw', '<cmd>w<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>baw', '<cmd>wa<CR>', { desc = '[W]rite all buffers' })
vim.keymap.set('n', '<leader>bQ', '<cmd>q<CR>', { desc = '[q]uit current' })
vim.keymap.set('n', 'Q', '<cmd>q<CR>', { desc = '[q]uit current' })
vim.keymap.set('n', '<leader>baQ', '<cmd>quitall!<CR>', { desc = '[q]uit' })
-- yanks on buffers
vim.keymap.set('n', '<leader>byp', function()
  local filepath = vim.fn.expand '%'
  vim.fn.setreg('+', filepath) -- write to clipboard register '+'
  vim.notify('Copied relative path: ' .. filepath, vim.log.levels.INFO)
end, { desc = 'Relative [P]ath' })
vim.keymap.set('n', '<leader>byP', function()
  local filepath = vim.fn.expand '%:p'
  vim.fn.setreg('+', filepath) -- write to clipboard register '+'
  vim.notify('Copied absolute path: ' .. filepath, vim.log.levels.INFO)
end, { desc = 'Absolute [P]ath' })
vim.keymap.set('n', '<leader>byn', function()
  local fn = vim.fn.expand '%:t'
  vim.fn.setreg('+', fn) -- write to clipboard register '+'
  vim.notify('Copied file name: ' .. fn, vim.log.levels.INFO)
end, { desc = '[N]ame' })
-- base64
vim.keymap.set('v', '<leader>b6e', "c<c-r>=system('base64',          @\")<cr><esc>", { desc = 'base64 encode' })
vim.keymap.set('v', '<leader>b6d', "c<c-r>=system('base64 --decode', @\")<cr><esc>", { desc = 'base64 decode' })
vim.keymap.set('v', '<leader>jq', ":%!jq '.' <enter>", { desc = 'pretty json' })

if vim.g.neovide then
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set({ 'n', 'v' }, '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
