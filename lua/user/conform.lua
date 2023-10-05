local status_ok, conform = pcall(require, "conform")
if not status_ok then
  return
end

conform.setup {
  -- Map of filetype to formatters
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { { "prettierd", "prettier" } },
    rust = { "rustfmt" },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = {
    -- I recommend these options. See :help conform.format for details.
    lsp_fallback = true,
    timeout_ms = 500,
  },
  format_after_save = {
    lsp_fallback = true,
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
}
