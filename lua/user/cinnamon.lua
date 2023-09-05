local status_ok, cinnamon = pcall(require, "cinnamon")
if not status_ok then
  return
end

cinnamon.setup {
  default_keymaps = true,
  extra_keymaps = false,
  extended_keymaps = false,
  override_keymaps = false,
  always_scroll = false,
  centered = true,
  disabled = false,
  default_delay = 7,
  hide_cursor = false,
  horizontal_scroll = true,
  max_length = -1,
  scroll_limit = 150,
}
