local M = {
  "danielfalk/smart-open.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("telescope").load_extension "telescope-tabs"
end

return M
