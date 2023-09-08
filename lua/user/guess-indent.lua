local status_ok, guess_indent = pcall(require, "guess-indent")
if not status_ok then
  return
end

guess_indent.setup {
  auto_cmd = true,
  override_editorconfig = false,
  filetype_exclude = {
    "netrw",
    "tutor",
    "NvimTree",
  },
  buftype_exclude = {
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
}
