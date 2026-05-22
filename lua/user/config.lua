-- User configuration file
-- This file is loaded before everything else, so all options set here
-- will be available to plugins and other configuration files.

---@class UserConfig
---@field completion_engine string
---@field mapleader string
---@field maplocalleader string
---@field restore_overseer_tasks boolean

---@type UserConfig
local M = {
  -- Completion engine: "nvim-cmp" or "blink"
  completion_engine = "blink",
  mapleader = "\\",
  maplocalleader = "\\",
  restore_overseer_tasks = false,
}

return M
