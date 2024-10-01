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

-- navigating buffers
vim.keymap.set('n', '<leader>bgn', ':bnext <enter>', { desc = '[n]ext' })
vim.keymap.set('n', '<leader>bgp', ':bprev <enter>', { desc = '[p]revious' })
vim.keymap.set('n', '<leader>bcd', ':bd <enter>', { desc = '[d]elete/close' })
vim.keymap.set('n', '<leader>bcw', ':w <enter>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>bad', ':%bd <enter>', { desc = '[d]elete/close' })
vim.keymap.set('n', '<leader>bcq', ':q <enter>', { desc = '[q]uit' })
vim.keymap.set('n', '<leader>baq', ':quitall <enter>', { desc = '[q]uit' })

vim.keymap.set('v', '<leader>b64e', "c<c-r>=system('base64',          @\")<cr><esc>", { desc = 'base64 encode' })
vim.keymap.set('v', '<leader>b64d', "c<c-r>=system('base64 --decode', @\")<cr><esc>", { desc = 'base64 decode' })
vim.keymap.set('v', '<leader>jq', ":%!jq '.' <enter>", { desc = 'pretty json' })
