local M = {
  "bjarneo/pixel.nvim",
  lazy = true,
}

M.init = function()
  if require("util.client").is_cui_client() then
    local available_colorschemes = vim.g.available_colorschemes or {}
    table.insert(available_colorschemes, "pixel")
    vim.g.available_colorschemes = available_colorschemes
  end
end

return M
