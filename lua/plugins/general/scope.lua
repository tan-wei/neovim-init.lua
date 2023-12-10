local M = {
  "tiagovla/scope.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "ScopeLoadState", "ScopeSaveState" },
}

M.config = function()
  require("scope").setup()
  require("telescope").load_extension "scope"
end

return M
