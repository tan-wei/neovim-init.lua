local M = {
  "datsfilipe/vesper.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "vesper")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("vesper").setup {
    transparent = false,
    italics = {
      comments = true,
      keywords = true,
      functions = true,
      strings = true,
      variables = true,
    },
    overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
    palette_overrides = {},
  }
end

return M
