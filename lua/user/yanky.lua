local status_ok, yanky = pcall(require, "yanky")
if not status_ok then
  return
end

yanky.setup {
  testobj = {
    enabled = true,
  },
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "yank_history"
