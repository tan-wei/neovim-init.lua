local M = {
  "dgrco/hearthlight.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "hearthlight")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  variant = "parchment", -- "parchment" | "ember" | "cinder" | "dusk"
  italics = true,
}

return M
