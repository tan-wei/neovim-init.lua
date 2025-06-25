local M = {
  "monkoose/matchparen.nvim",
  event = "VeryLazy",
}

M.init = function()
  vim.g.loaded_matchparen = 1
end

M.config = function()
  require("matchparen").setup {
    on_startup = true,
    hl_group = "MatchParen",
    augroup_name = "matchparen",
    debounce_time = 60,
  }
end

return M
