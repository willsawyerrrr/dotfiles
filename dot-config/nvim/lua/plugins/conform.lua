-- Conform can also run multiple formatters sequentially
-- You can use 'stop_after_first' to run the first available formatter from the list
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

return {
  -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,

    ---@module 'conform'
    ---@type conform.FiletypeFormatter
    formatters_by_ft = {
      lua = { 'stylua' },

      javascript = prettier,
      typescript = prettier,
      javascriptreact = prettier,
      typescriptreact = prettier,
      json = prettier,
      css = prettier,
      scss = prettier,
      less = prettier,
      html = prettier,
      markdown = prettier,
      yaml = prettier,

      terraform = { 'terraform_fmt' },
    },
  },
}
