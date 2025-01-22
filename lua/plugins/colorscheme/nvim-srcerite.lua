local M = {
  "m15a/nvim-srcerite",
  dependencies = {
    "Iron-E/nvim-highlite",
  },
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "srcerite")
  vim.g.available_colorschemes = available_colorschemes
end

return M
