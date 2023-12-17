local M = {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
}

-- TODO: Add lint progress by require("lint").get_running()
M.config = function()
  require("lint").linters_by_ft = {
    cpp = { "clangtidy", "cppcheck" },
  }
end

return M
