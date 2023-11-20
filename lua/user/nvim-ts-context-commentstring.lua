local status_ok, ts_context_commentstring = pcall(require, "ts_context_commentstring")
if not status_ok then
  return
end

ts_context_commentstring.setup {
  enable_autocmd = false,
}
