local M = {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = function()
    if not require("util.os").is_windows() then
      local job = require "plenary.job"
      job
        :new({
          command = "make",
          args = { "install_jsregexp" },
          cwd = vim.fn.stdpath "data" .. "/lazy/LuaSnip",
        })
        :sync()
    end
  end,
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = {
    "InsertEnter",
  },
}

M.config = function()
  local luasnip = require "luasnip"

  require("luasnip/loaders/from_vscode").lazy_load()

  local snippets = require "user.snippets"

  for lang, snippet in pairs(snippets) do
    luasnip.add_snippets(lang, snippet)
  end
end

return M
