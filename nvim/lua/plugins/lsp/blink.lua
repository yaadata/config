local VERSION = 'v1.8.0'

local opts = { -- Autocompletion
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    'kristijanhusak/vim-dadbod-completion',
    'giuxtaposition/blink-cmp-copilot',
    'onsails/lspkind.nvim',
  },
  event = 'VeryLazy',
  version = VERSION,
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'default',
      ['<A-1>'] = {
        function(cmp)
          cmp.accept { index = 1 }
        end,
      },
      ['<A-2>'] = {
        function(cmp)
          cmp.accept { index = 2 }
        end,
      },
      ['<A-3>'] = {
        function(cmp)
          cmp.accept { index = 3 }
        end,
      },
      ['<A-4>'] = {
        function(cmp)
          cmp.accept { index = 4 }
        end,
      },
      ['<A-5>'] = {
        function(cmp)
          cmp.accept { index = 5 }
        end,
      },
      ['<A-6>'] = {
        function(cmp)
          cmp.accept { index = 6 }
        end,
      },
      ['<A-7>'] = {
        function(cmp)
          cmp.accept { index = 7 }
        end,
      },
      ['<A-8>'] = {
        function(cmp)
          cmp.accept { index = 8 }
        end,
      },
      ['<A-9>'] = {
        function(cmp)
          cmp.accept { index = 9 }
        end,
      },
      ['<A-0>'] = {
        function(cmp)
          cmp.accept { index = 10 }
        end,
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    completion = {
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = 'full' },

      -- Disable auto brackets
      -- NOTE: some LSPs may add auto brackets themselves anyway
      accept = { auto_brackets = { enabled = false } },

      -- Don't select by default, auto insert on selection
      list = { selection = { preselect = false, auto_insert = true } },

      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 150 },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },

      -- Menu settings
      menu = {
        draw = {
          columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require('lspkind').symbolic(ctx.kind, {
                    mode = 'symbol',
                  })
                end

                return icon .. ctx.icon_gap
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
            item_idx = {
              text = function(ctx)
                return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx)
              end,
              highlight = 'BlinkCmpItemIdx', -- optional, only if you want to change its color
            },
          },
        },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = {
        'lsp',
        'snippets',
        'copilot',
        'path',
        'buffer',
        'dadbod',
      },
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
          score_offset = 100,
        },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = 'Copilot'
            for _, item in ipairs(items) do
              item.kind = kind_idx
              item.kind_icon = ''
            end
            return items
          end,
        },
      },
    },
  },
  fuzzy = {
    prebuilt_binaries = {
      force_version = VERSION,
    },
  },
  term = {
    enabled = false,
  },
  -- Experimental signature help support
  signature = {
    enabled = true,
    trigger = {
      enabled = true,
      show_on_insert = true,
    },
  },
  opts_extend = { 'sources.default' },
}

return opts
