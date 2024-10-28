local opts = {
  'stevearc/overseer.nvim',
  opts = {},
  config = function()
    require('overseer').setup {
      templates = {
        'rust',
      },
    }
    local os = require 'overseer'
    vim.keymap.set({ 'n' }, '<leader>Tt', function()
      os.toggle {
        enter = false,
        direction = 'left',
      }
    end, { desc = '[T]oggle Task List' })
    vim.keymap.set({ 'n' }, '<leader>Ta', '<cmd>OverseerTaskAction<CR>', { desc = '[A]ction on Task' })
    vim.keymap.set({ 'n' }, '<leader>Tc', '<cmd>OverseerBuild<CR>', { desc = '[C]reate new task' })
    vim.keymap.set({ 'n' }, '<leader>Ts', '<cmd>OverseerRun<CR>', { desc = '[S]earch and Run' })
    vim.keymap.set({ 'n' }, '<leader>Tr', function()
      local tasks = os.list_tasks { recent_first = true }
      if vim.tbl_isempty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
      else
        os.run_action(tasks[1], 'restart')
      end
    end, { desc = '[R]erun Recent Task' })
  end,
}

return opts
