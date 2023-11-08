local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
  return
end

lsp_signature.setup {
  log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log",
  debug = true,
  hint_enable = false,
  handler_opts = { border = "rounded" },
  max_width = 80,
  noice = true,
}
