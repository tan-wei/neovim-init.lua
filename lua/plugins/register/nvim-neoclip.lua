local M = {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    { "kkharji/sqlite.lua", module = "sqlite" },
  },
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("neoclip").setup()
  require("telescope").load_extension "neoclip"
end

return M
