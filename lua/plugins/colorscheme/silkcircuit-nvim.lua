local M = {
  "hyperb1iss/silkcircuit-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "silkcircuit")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("silkcircuit").setup {
    variant = "neon", -- Theme variant: "neon" | "vibrant" | "soft" | "glow" | "dawn"
  }
end

return M
