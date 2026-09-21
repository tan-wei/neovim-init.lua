---@type LazyPluginSpec
local M = {
  "dzfrias/arena.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "BufWinEnter",
  enabled = false,
}

-- TODO: Maybe we should use this one instead of buffer_manager
M.opts = {
  max_items = 5,
  always_context = { "mod.rs", "init.lua" },
  ignore_current = false,
  buf_opts = {
    -- ["relativenumber"] = false,
  },
  per_project = true,
  devicons = true,
  window = {
    width = 60,
    height = 10,
    border = "rounded",
    opts = {},
  },
  keybinds = {
    -- ["e"] = function()
    --   vim.cmd("echo \"Hello from the arena!\"")
    -- end
  },
  renderers = {},
  algorithm = {
    recency_factor = 0.5,
    frequency_factor = 1,
  },
}

return M
