local status_ok, legendary = pcall(require, "legendary")
if not status_ok then
  return
end

legendary.setup {
  entensions = {
    nvim_tree = true,
    lazy_nvim = true,
    which_key = {
      auto_register = true,
    },
    diffview = true,
  },
}
