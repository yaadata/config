local function current_file_path()
  local path = vim.fn.expand '%'
  if path == '' then
    vim.notify('Current buffer has no file path', vim.log.levels.WARN)
    return nil
  end

  return path
end

local function current_buffer_dir()
  local path = vim.fn.expand '%:p:h'
  if path == '' then
    return vim.fn.getcwd()
  end

  return path
end

local opts = {
  'MagicDuck/grug-far.nvim',
  version = '1.6.67',
  opts = {},
  cmd = { 'GrugFar', 'GrugFarWithin' },
  keys = {
    {
      '<leader>sxp',
      function()
        require('grug-far').open()
      end,
      desc = '[S]earch Replace in [P]roject',
    },
    {
      '<leader>sxf',
      function()
        local path = current_file_path()
        if not path then
          return
        end

        require('grug-far').open {
          prefills = {
            paths = path,
          },
        }
      end,
      desc = '[S]earch Replace in Current [F]ile',
    },
    {
      '<leader>sxd',
      function()
        require('grug-far').open {
          prefills = {
            paths = current_buffer_dir(),
          },
        }
      end,
      desc = '[S]earch Replace in Current [D]irectory',
    },
    {
      '<leader>sxs',
      function()
        local path = current_file_path()
        if not path then
          return
        end

        require('grug-far').with_visual_selection {
          prefills = {
            paths = path,
          },
          visualSelectionUsage = 'auto-detect',
        }
      end,
      mode = 'x',
      desc = '[S]earch Replace in Visual [S]election',
    },
  },
}

return opts
