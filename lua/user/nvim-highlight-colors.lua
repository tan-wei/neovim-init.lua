local status_ok, nvim_highlight_colors = pcall(require, "nvim-highlight-colors")
if not status_ok then
  return
end

nvim_highlight_colors.setup {
  render = "background",
  enable_named_colors = true,
  enable_tailwind = true,
}
