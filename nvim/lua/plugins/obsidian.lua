local opts = {
  'obsidian-nvim/obsidian.nvim',
  version = 'v3.16.9',
  ft = 'markdown',
  cmd = 'Obsidian',
  dependencies = { 'ibhagwan/fzf-lua' },
  ---@module "obsidian"
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = 'omni',
        path = '~/repositories/yaadata/obsidian/omni',
      },
    },
    -- MUST be explicit: telescope.nvim is installed, and obsidian auto-probes
    -- telescope -> fzf-lua -> mini -> snacks. Without this you would get telescope.
    picker = { name = 'fzf-lua' },

    -- vault uses human filenames ("Quick Sort.md"), not zettel timestamps
    note_id_func = function(title)
      return require('obsidian.builtin').title_id(title)
    end,

    -- all existing notes use shortest-path wiki links: [[Bit Manipulation]]
    link = { style = 'wiki', format = 'shortest' },

    daily_notes = { enabled = true, folder = 'daily', date_format = 'YYYY-MM-DD' },
    templates = { folder = 'Templates', date_format = 'YYYY-MM-DD', time_format = 'HH:mm' },

    attachments = { folder = 'attachments' },
    completion = { min_chars = 2 },

    -- `:Obsidian open` delegates to vim.ui.open with an obsidian:// URI.
    -- use_advanced_uri stays false: it needs the "Advanced URI" community
    -- plugin, which this vault does not have installed (only excalidraw + git).
    open = {
      use_advanced_uri = false,
      func = function(uri)
        -- obsidian.nvim builds the URI with vim.uri_encode, which does not
        -- escape '&'. Notes whose path contains '&' ("Algorithms & Data
        -- Structures/Quick Sort.md") would otherwise produce a URI that the
        -- Obsidian app parses as extra query params.
        local prefix, file = uri:match '^(.-[?&]file=)(.*)$'
        if prefix and file then
          uri = prefix .. (file:gsub('&', '%%26'))
        end
        vim.ui.open(uri)
      end,
    },

    -- checkbox / callout / bullet rendering. Requires conceallevel = 2, which is
    -- set for markdown buffers in after/ftplugin/markdown.lua (see issue #286).
    ui = { enable = true },
    footer = { enabled = true },

    callbacks = {
      -- obsidian.nvim defines `M.setup()` in lua/obsidian/picker/fzf.lua (which
      -- registers the `obsidian_files` / `obsidian_grep` fzf-lua extensions) but
      -- never calls it. Without this, :FzfLua obsidian_files does not exist.
      post_setup = function()
        require('obsidian.picker.fzf').setup()
      end,
    },
  },
  keys = {
    { '<leader>os', '<cmd>Obsidian quick_switch<cr>', desc = '[O]bsidian Quick Switch' },
    { '<leader>on', '<cmd>Obsidian new<cr>', desc = '[O]bsidian [N]ew Note' },
    { '<leader>ot', '<cmd>Obsidian today<cr>', desc = '[O]bsidian Today' },
    { '<leader>od', '<cmd>Obsidian dailies<cr>', desc = '[O]bsidian [D]ailies' },
    { '<leader>so', '<cmd>Obsidian search<cr>', desc = '[O]bsidian [S]earch Vault' },
    { '<leader>og', '<cmd>Obsidian tags<cr>', desc = '[O]bsidian Ta[g]s' },
    { '<leader>oB', '<cmd>Obsidian bookmarks<cr>', desc = '[O]bsidian [B]ookmarks' },
    { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = '[O]bsidian [B]acklinks' },
    { '<leader>ol', '<cmd>Obsidian links<cr>', desc = '[O]bsidian [L]inks' },
    { '<leader>oT', '<cmd>Obsidian toc<cr>', desc = '[O]bsidian [T]able of Contents' },
    { '<leader>oR', '<cmd>Obsidian rename<cr>', desc = '[O]bsidian [R]ename Note' },
    { '<leader>ow', '<cmd>Obsidian workspace<cr>', desc = '[O]bsidian [W]orkspace' },
    { '<leader>oo', '<cmd>Obsidian open<cr>', desc = '[O]pen Current Note in Obsidian App' },
    { '<leader>oc', '<cmd>Obsidian check<cr>', desc = '[O]bsidian [C]heck Vault' },
    {
      '<leader>op',
      function()
        require('obsidian.actions').add_property()
      end,
      desc = '[O]bsidian Add [P]roperty',
    },
    { '<leader>ox', '<cmd>Obsidian toggle_checkbox<cr>', desc = '[O]bsidian Toggle Checkbox' },
    {
      '<leader>ox',
      ":'<,'>Obsidian toggle_checkbox<cr>",
      desc = '[O]bsidian Toggle Checkbox',
      mode = 'x',
    },
  },
}

return opts
