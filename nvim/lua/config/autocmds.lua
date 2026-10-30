-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_format = 'fallback', range = range }
end, { range = true })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'qf', 'gitcommit', 'oil', 'fyler' },
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    if filetype ~= 'atlas' and not vim.startswith(filetype, 'atlas.') then
      return
    end

    for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
      vim.api.nvim_set_option_value('spell', false, { win = win, scope = 'local' })
    end
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    if vim.bo[args.buf].buftype == 'terminal' then
      vim.opt_local.spell = false
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
  callback = function()
    local cmdline = vim.fn.getcmdline()
    if vim.fn.getcmdtype() ~= ':' then
      return
    end
    if not cmdline:match '^Obsidian[A-Za-z0-9]*$' then
      return
    end
    vim.fn.wildtrigger()
  end,
})

vim.api.nvim_create_user_command('LazyGitToggle', require('utils.lazygit').toggle, {})
vim.api.nvim_create_user_command('K9sToggle', require('utils.k9s').toggle, {})
vim.api.nvim_create_user_command('TaskwarriorToggle', require('utils.taskwarrior').toggle, {})

-- Terminal Status Group
--
-- Used by emulator's such as Rex / Herdr
-- Forward Pi's terminal status to Rex from Neovim's terminal buffer.
if not vim.env.REX_BLOCK or vim.fn.has 'nvim-0.12' == 0 then
  return
end

local osc = '\27]7501;'
local st = '\27\\'
local active = {}
local terminalProgramStatusGroup = vim.api.nvim_create_augroup('TerminalProgramStatus', { clear = true })

local function tty_ui()
  local uis = vim.api.nvim_list_uis()
  return #uis == 1 and uis[1].stdout_tty
end

local function id(buf)
  return ('nvim%d-b%d'):format(vim.fn.getpid(), buf)
end

vim.api.nvim_create_autocmd('TermRequest', {
  group = terminalProgramStatusGroup,
  desc = 'Forward terminal program status to Rex',
  callback = function(ev)
    local seq = ev.data.sequence
    if not tty_ui() or seq:sub(1, #osc) ~= osc then
      return
    end

    if seq == osc .. '?' then
      -- Pi checks whether its immediate terminal supports program status.
      pcall(vim.api.nvim_chan_send, vim.bo[ev.buf].channel, osc .. '?' .. st)
    else
      active[ev.buf] = true
      vim.api.nvim_ui_send(seq .. ':id=' .. id(ev.buf) .. st)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'TermClose', 'BufWipeout' }, {
  group = terminalProgramStatusGroup,
  desc = 'Clear a terminal buffer’s Rex program status',
  callback = function(ev)
    if active[ev.buf] and tty_ui() then
      vim.api.nvim_ui_send(osc .. 'state=clear:id=' .. id(ev.buf) .. st)
      active[ev.buf] = nil
    end
  end,
})
