local M = {
  "danymat/neogen",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  cmd = "Neogen",
}

M.config = function()
  require("neogen").setup {
    snippet_engine = "luasnip",
    languages = {
      ["cpp.doxygen"] = require "neogen.configurations.cpp",
      ["c.doxygen"] = require "neogen.configurations.c",
    },
  }
end

return M
