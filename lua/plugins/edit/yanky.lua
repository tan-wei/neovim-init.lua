---@type LazyPluginSpec
local M = {
  "gbprod/yanky.nvim",
  lazy = false,
  dependencies = {
    "kkharji/sqlite.lua",
  },
  cmd = {
    "YankyClearHistory",
    "YankyRingHistory",
  },
}

-- TODO: Integerate with other plugins

M.config = function()
  local yanky = require "yanky"
  local yanky_utils = require "yanky.utils"
  local upstream_get_default_register = yanky_utils.get_default_register

  yanky_utils.get_default_register = function()
    local register = upstream_get_default_register()

    -- In this setup, native y/p still round-trip through the unnamed register
    -- even with `clipboard=unnamedplus`, while Yanky's heuristic prefers `+`.
    -- Keep Yanky aligned with native paste behavior so `yy` followed by `p`
    -- reuses the most recent yank instead of stale system clipboard content.
    if register == "+" or register == "*" then
      return '"'
    end

    return register
  end
  -- Some clipboard providers expose non-text payloads as unreadable registers.
  -- Skip seeding Yanky's history on startup when the default register can't be read.
  yanky.init_history = function()
    local item = yanky_utils.get_register_info(yanky_utils.get_default_register())
    if item == nil then
      return
    end

    yanky.history.push(item)
    yanky.history.sync_with_numbered_registers()
  end

  yanky.setup {
    ring = {
      history_length = 200,
      storage = "sqlite",
    },
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 1000,
    },
  }
end

return M
