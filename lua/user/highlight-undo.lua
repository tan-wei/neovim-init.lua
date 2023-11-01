local status_ok, highlight_undo = pcall(require, "highlight-undo")
if not status_ok then
  return
end

highlight_undo.setup {
  duration = 1000,
}
