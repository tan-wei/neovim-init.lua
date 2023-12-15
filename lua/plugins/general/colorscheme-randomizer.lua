local M = {
  "jay-babu/colorscheme-randomizer.nvim",
  tag = "v1.0.0",
}

M.config = function()
  require("colorscheme-randomizer").setup {
    apply_scheme = true,
    plugin_strategy = "lazy",
    plugins = vim.g.available_colorschemes,
    colorschemes = vim.g.available_colorschemes,
  }
end

return M
