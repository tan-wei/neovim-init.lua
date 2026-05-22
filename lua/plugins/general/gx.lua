---@type LazyPluginSpec
local M = {
  "chrishrb/gx.nvim",
  cmd = { "Browse" },
  submodules = false,
}

M.init = function()
  vim.g.netrw_nogx = 1 -- disable netrw gx
end

M.opts = {}

return M
