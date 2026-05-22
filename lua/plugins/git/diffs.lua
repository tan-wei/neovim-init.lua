---@type LazyPluginSpec
local M = {
  "barrettruth/diffs.nvim",
  lazy = false, -- NOTE: diffs.nvim lazy-loads itself
}

M.init = function()
  vim.g.diffs = {
    integrations = {
      fugitive = true,
      neogit = true,
      neojj = false,
      gitsigns = true,
    },
  }
end

return M
