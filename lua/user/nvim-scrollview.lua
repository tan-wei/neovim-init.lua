local status_ok, scrollview = pcall(require, "scrollview")
if not status_ok then
  return
end

scrollview.setup {
  excluded_filetypes = {},
  current_only = true,
}
