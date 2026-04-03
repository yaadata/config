local M = {}

M.move_left = function(amount)
  local cur = vim.fn.winnr()
  local left = vim.fn.winnr 'h'
  local right = vim.fn.winnr 'l'

  if left ~= cur then
    vim.fn.win_move_separator(vim.fn.win_getid(left), -amount)
  elseif right ~= cur then
    vim.fn.win_move_separator(vim.api.nvim_get_current_win(), -amount)
  end
end

M.move_right = function(amount)
  local cur = vim.fn.winnr()
  local left = vim.fn.winnr 'h'
  local right = vim.fn.winnr 'l'

  if right ~= cur then
    vim.fn.win_move_separator(vim.api.nvim_get_current_win(), amount)
  elseif left ~= cur then
    vim.fn.win_move_separator(vim.fn.win_getid(left), amount)
  end
end

M.move_up = function(amount)
  local cur = vim.fn.winnr()
  local up = vim.fn.winnr 'k'
  local down = vim.fn.winnr 'j'

  if up ~= cur then
    vim.fn.win_move_statusline(vim.fn.win_getid(up), -amount)
  elseif down ~= cur then
    vim.fn.win_move_statusline(vim.api.nvim_get_current_win(), -amount)
  end
end

M.move_down = function(amount)
  local cur = vim.fn.winnr()
  local up = vim.fn.winnr 'k'
  local down = vim.fn.winnr 'j'

  if down ~= cur then
    vim.fn.win_move_statusline(vim.api.nvim_get_current_win(), amount)
  elseif up ~= cur then
    vim.fn.win_move_statusline(vim.fn.win_getid(up), amount)
  end
end

return M

