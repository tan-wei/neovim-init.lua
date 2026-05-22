---@type LazyPluginSpec
local M = {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      {
        path = "lazy.nvim",
        words = { "LazyPluginSpec", "LazySpec", "LazyConfig", "LazySpecImport" },
      },
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}

return M
