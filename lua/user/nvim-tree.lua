local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local nvim_tree_api = require "nvim-tree.api"
local nvim_tree_open = {}

nvim_tree_api.events.subscribe(nvim_tree_api.events.Event.TreeOpen, function()
  nvim_tree_open[vim.api.nvim_get_current_tabpage()] = true
end)
nvim_tree_api.events.subscribe(nvim_tree_api.events.Event.TreeClose, function()
  nvim_tree_open[vim.api.nvim_get_current_tabpage()] = false
end)

-- Open on startup
vim.api.nvim_create_autocmd({ "VimEnter", "TabNew", "TabNewEntered", "TabEnter" }, {
  callback = function(data)
    if nvim_tree_open[vim.api.nvim_get_current_tabpage()] then
      return
    end
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    if not real_file and not no_name then
      return
    end

    -- open the tree, find the file but don't focus it
    nvim_tree_api.tree.toggle { focus = false, find_file = true }
  end,
})

-- Auto close
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if
      layout[1] == "leaf"
      and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
      and layout[3] == nil
    then
      vim.cmd "confirm quit"
    end
  end,
})

nvim_tree.setup {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    git_ignored = false,
  },
}
