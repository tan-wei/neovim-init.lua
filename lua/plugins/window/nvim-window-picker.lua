---@type LazyPluginSpec
local M = {
  "s1n7ax/nvim-window-picker",
  cmd = "WindowPick",
}

M.config = function()
  require("window-picker").setup {
    filter_rules = {
      bo = {
        filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif", "smear-cursor" },
        buftype = { "terminal", "nofile", "quickfix" },
      },
    },
  }

  vim.api.nvim_create_user_command("WindowPick", function()
    local win = require("window-picker").pick_window()
    if win then
      vim.api.nvim_set_current_win(win)
    end
  end, { desc = "Pick and focus a window" })
end

return M
