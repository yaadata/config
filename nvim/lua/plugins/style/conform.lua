local opts = { -- Autoformat
  'stevearc/conform.nvim',
  tag = 'v9.1.0',
  lazy = false,
  keys = {
    {
      '<leader>bf',
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat

        local status = vim.b.disable_autoformat and 'disabled' or 'enabled'
        local scope = vim.g.disable_autoformat and ' for this buffer (global autoformat is still disabled)' or ' for this buffer'
        vim.notify('Autoformat ' .. status .. scope)
      end,
      mode = '',
      desc = 'Toggle [F]ormat',
    },
  },
  opts = {
    notify_on_error = false,
    formatters = {
      pkl = {
        command = 'pkl',
        args = { 'format', '-w', '$FILENAME' },
        stdin = false,
      },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 750,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'ruff', 'black' },
      go = { 'gofmt', 'goimports' },
      typescript = { 'eslint_d' },
      markdown = { 'deno_fmt' },
      toml = { 'tombi' },
      terraform = { 'terraform_fmt' },
      pkl = { 'pkl' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
      sql = { 'sql_formatter' },
      ['*'] = { 'injected' }, -- enables injected-lang formatting for all filetypes
    },
  },
}

return opts
