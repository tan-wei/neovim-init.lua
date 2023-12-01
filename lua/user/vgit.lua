local status_ok, vgit = pcall(require, "vgit")
if not status_ok then
  return
end

-- TODO: Keybindings should be configured with which-key
vgit.setup {
  settings = {
    live_blame = {
      enabled = false,
    },
    live_gutter = {
      enabled = false,
    },
  },
}
