local M = {
  "Mr-LLLLL/interestingwords.nvim",
  enabled = false,
}

M.config = function()
  require("interestingwords").setup {
    colors = { "#aeee00", "#ff0000", "#0000ff", "#b88823", "#ffa724", "#ff2c4b" },
    search_count = true,
    navigation = true,
    scroll_center = true,
    search_key = "<leader>m",
    cancel_search_key = "<leader>M",
    color_key = "<leader>k",
    cancel_color_key = "<leader>K",
    select_mode = "random", -- random or loop
  }

  -- TODO: lualine integrated
  -- require("lualine").setup {
  --   lualine_x = {
  --     {
  --       require("interestingwords").lualine_get,
  --       cond = require("interestingwords").lualine_has,
  --       color = { fg = "#ff9e64" },
  --     },
  --   },
  -- }
end

return M
