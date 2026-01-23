local opts = {
  'stevearc/overseer.nvim',
  opts = {},
  tag = 'v1.6.0',
  config = function()
    require('overseer').setup {
      templates = {
        'rust',
        'golang',
      },
    }
    local os = require 'overseer'
    vim.keymap.set({ 'n' }, '<leader>pt', function()
      os.toggle {
        enter = false,
        direction = 'left',
      }
    end, { desc = '[T]oggle Task Runs' })
    vim.keymap.set({ 'n' }, '<leader>pa', '<cmd>OverseerTaskAction<CR>', { desc = 'Previous [A]ctions' })
    vim.keymap.set({ 'n' }, '<leader>pc', '<cmd>OverseerBuild<CR>', { desc = '[C]reate new task' })
    vim.keymap.set({ 'n' }, '<leader>ps', '<cmd>OverseerRun<CR>', { desc = '[S]earch/[S]elect tasks' })
    vim.keymap.set({ 'n' }, '<leader>pp', function()
      local tasks = os.list_tasks { recent_first = true }
      if vim.tbl_isempty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
      else
        os.run_action(tasks[1], 'restart')
      end
    end, { desc = 'Run [P]revious Task' })
  end,
}

return opts
