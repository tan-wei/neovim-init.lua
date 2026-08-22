---@type LazyPluginSpec
local M = {
  "WeiTing1991/suannhai.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "suannhai-jiufen")
  table.insert(available_colorschemes, "suannhai-lam-ni")
  table.insert(available_colorschemes, "suannhai-rouiro")
  table.insert(available_colorschemes, "suannhai-sumi")
  table.insert(available_colorschemes, "suannhai-koiai")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
