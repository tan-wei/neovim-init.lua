---@type LazyPluginSpec
local M = {
  "iurimateus/luasnip-latex-snippets.nvim",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "lervag/vimtex",
  },
  ft = {
    "tex",
    "plaintex",
  },
}

M.config = function()
  require("luasnip-latex-snippets").setup {
    allow_on_markdown = false,
  }
end

return M
