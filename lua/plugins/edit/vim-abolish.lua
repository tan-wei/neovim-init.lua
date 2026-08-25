---@type LazyPluginSpec
local M = {
  "tpope/vim-abolish",
  cmd = { "Abolish", "Subvert" },
}

M.init = function()
  vim.g.abolish_no_mappings = true
end

return M
