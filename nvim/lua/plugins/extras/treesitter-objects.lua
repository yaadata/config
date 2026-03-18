local opts = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  commit = '4e91b5d0394329a229725b021a8ea217099826ef',
  config = function()
    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'

    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    }

    local function select_textobject(query_string)
      return function()
        select.select_textobject(query_string, 'textobjects')
      end
    end

    local function move_textobject(method, query_string)
      return function()
        move[method](query_string, 'textobjects')
      end
    end

    local function swap_textobject(method, query_string)
      return function()
        swap[method](query_string, 'textobjects')
      end
    end

    -- You can use the capture groups defined in textobjects.scm
    vim.keymap.set({ 'x', 'o' }, 'aa', select_textobject '@parameter.outer', { desc = 'Treesitter around parameter' })
    vim.keymap.set({ 'x', 'o' }, 'ia', select_textobject '@parameter.inner', { desc = 'Treesitter inner parameter' })
    vim.keymap.set({ 'x', 'o' }, 'af', select_textobject '@function.outer', { desc = 'Treesitter around function' })
    vim.keymap.set({ 'x', 'o' }, 'if', select_textobject '@function.inner', { desc = 'Treesitter inner function' })
    vim.keymap.set({ 'x', 'o' }, 'ac', select_textobject '@class.outer', { desc = 'Treesitter around class' })
    vim.keymap.set({ 'x', 'o' }, 'ic', select_textobject '@class.inner', { desc = 'Treesitter inner class' })
    vim.keymap.set({ 'x', 'o' }, 'ar', select_textobject '@assignment.rhs', { desc = 'Treesitter assignment rhs' })
    vim.keymap.set({ 'x', 'o' }, 'al', select_textobject '@assignment.lhs', { desc = 'Treesitter assignment lhs' })

    vim.keymap.set({ 'n', 'x', 'o' }, ']m', move_textobject('goto_next_start', '@function.outer'), { desc = 'Treesitter next function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']]', move_textobject('goto_next_start', '@class.outer'), { desc = 'Treesitter next class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', move_textobject('goto_next_end', '@function.outer'), { desc = 'Treesitter next function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '][', move_textobject('goto_next_end', '@class.outer'), { desc = 'Treesitter next class end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', move_textobject('goto_previous_start', '@function.outer'), { desc = 'Treesitter previous function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[[', move_textobject('goto_previous_start', '@class.outer'), { desc = 'Treesitter previous class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', move_textobject('goto_previous_end', '@function.outer'), { desc = 'Treesitter previous function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[]', move_textobject('goto_previous_end', '@class.outer'), { desc = 'Treesitter previous class end' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']i', move_textobject('goto_next', '@conditional.outer'), { desc = 'Treesitter next conditional' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', move_textobject('goto_next', '@parameter.outer'), { desc = 'Treesitter next parameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']r', move_textobject('goto_next', '@assignment.rhs'), { desc = 'Treesitter next assignment rhs' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']l', move_textobject('goto_next', '@assignment.lhs'), { desc = 'Treesitter next assignment lhs' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[i', move_textobject('goto_previous', '@conditional.outer'), { desc = 'Treesitter previous conditional' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[a', move_textobject('goto_previous', '@parameter.outer'), { desc = 'Treesitter previous parameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[r', move_textobject('goto_previous', '@assignment.rhs'), { desc = 'Treesitter previous assignment rhs' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[l', move_textobject('goto_previous', '@assignment.lhs'), { desc = 'Treesitter previous assignment lhs' })

    vim.keymap.set('n', '<leader>vta', swap_textobject('swap_next', '@parameter.inner'), { desc = 'Treesitter swap next parameter' })
    vim.keymap.set('n', '<leader>vtA', swap_textobject('swap_previous', '@parameter.inner'), { desc = 'Treesitter swap previous parameter' })
  end,
}

return opts
