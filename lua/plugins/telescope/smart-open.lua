local M = {
  "danielfalk/smart-open.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  event = "VeryLazy",
  enabled = not require("util.os").is_windows(),
}

M.config = function()
  require("telescope").load_extension "smart_open"
end

return M
