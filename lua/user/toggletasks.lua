local status_ok, toggletasks = pcall(require, "toggletasks")
if not status_ok then
  return
end

-- TODO: Configure for toggletasks.nvim
toggletasks.setup {
  silent = true,
  search_paths = {
    "toggletasks",
    ".toggletasks",
    ".nvim/toggletasks",
  },
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "toggletasks"
