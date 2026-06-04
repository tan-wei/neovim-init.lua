---@type LazyPluginSpec
local M = {
  "folke/zen-mode.nvim",
  dependencies = {
    "folke/twilight.nvim",
    "TaDaa/vimade",
  },
  cmd = "ZenMode",
}

local vimade_was_enabled = false

local function has_vimade_command(command)
  return vim.fn.exists(":" .. command) == 2
end

local function is_vimade_enabled()
  return has_vimade_command "VimadeEnable" and vim.g.vimade_running == 1
end

local function set_vimade_enabled(enabled)
  if not has_vimade_command "VimadeEnable" then
    return
  end

  vim.cmd(enabled and "VimadeEnable" or "VimadeDisable")
end

M.config = function()
  require("zen-mode").setup {
    on_open = function(_win)
      vimade_was_enabled = is_vimade_enabled()
      if vimade_was_enabled then
        set_vimade_enabled(false)
      end
    end,
    on_close = function()
      if vimade_was_enabled then
        set_vimade_enabled(true)
        vimade_was_enabled = false
      end
    end,
  }
end

return M
