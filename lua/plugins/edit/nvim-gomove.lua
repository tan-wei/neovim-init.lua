local M = {
  "booperlv/nvim-gomove",
  lazy = true,
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("gomove").setup {
    map_defaults = false,
    reindent = false,
    undojoin = false,
    move_past_end_col = false,
  }
end

return M
