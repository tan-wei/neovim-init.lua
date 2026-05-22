---@type LazyPluginSpec
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

  luasnip.config.setup {
    delete_check_events = "TextChanged",
    enable_autosnippets = true,
    region_check_events = "InsertEnter",
  }

  -- Keep choice switching off Tab so it doesn't fight blink's menu navigation.
  -- Use plain function mappings here: the expr+fallback variant can interfere
  -- with select-mode choice cycling after snippet expansion.
  vim.keymap.set({ "i", "s" }, "<C-n>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end, { silent = true, desc = "LuaSnip next choice" })

  vim.keymap.set({ "i", "s" }, "<C-p>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(-1)
    end
  end, { silent = true, desc = "LuaSnip previous choice" })

  require("luasnip/loaders/from_vscode").lazy_load()

  local snippets = require "user.snippets"

  for lang, snippet in pairs(snippets) do
    luasnip.add_snippets(lang, snippet)
  end
end

return M
