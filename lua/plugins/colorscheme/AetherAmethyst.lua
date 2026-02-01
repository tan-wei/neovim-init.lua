local M = {
  "aethersyscall/AetherAmethyst.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "aetheramethyst-eclipse")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("aetheramethyst").setup {
    transparent = false, -- Enable transparent background
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = { bold = true },
      variables = {},
    },
  }
end

return M
