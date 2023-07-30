local M = {
  "glepnir/zephyr-nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zephyr")
  vim.g.available_colorschemes = available_colorschemes
end

return M
