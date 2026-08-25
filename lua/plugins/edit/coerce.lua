---@type LazyPluginSpec
local M = {
  "gregorias/coerce.nvim",
  event = "VeryLazy",
  dependencies = {
    "gregorias/coop.nvim",
    "folke/which-key.nvim",
  },
}

M.config = function()
  require("coerce").setup()

  local function action(mode_name)
    return function()
      require("coerce.keymaps").action(require("coerce.mode")[mode_name])
    end
  end

  local normal_action = action "normal_mode"
  local motion_action = action "motion_mode"
  local visual_action = action "visual_mode"

  local wk = require "which-key"

  local wke = require("coerce.keymaps").which_key_expand
  local function show_or_fallback(prefix, mode, fallback)
    return function()
      local ok_config, wk_config = pcall(require, "which-key.config")
      local ready = ok_config and wk.did_setup and wk_config.loaded and wk_config.triggers and wk_config.triggers.modes
      if ready then
        local shown = pcall(wk.show, {
          keys = prefix,
          mode = mode,
        })
        if shown then
          return
        end
      end

      fallback()
    end
  end

  vim.keymap.set("n", "cr", show_or_fallback("cr", "n", normal_action), { desc = "Coerce word" })
  vim.keymap.set("n", "gcr", show_or_fallback("gcr", "n", motion_action), { desc = "Coerce motion" })
  vim.keymap.set("x", "gcr", show_or_fallback("gcr", "x", visual_action), { desc = "Coerce visual" })

  wk.add {
    { "cr", group = "+Coerce word", expand = wke.normal_mode, mode = "n" },
    { "gcr", group = "+Coerce motion", expand = wke.motion_mode, mode = "n" },
    { "gcr", group = "+Coerce visual", expand = wke.visual_mode, mode = "x" },
  }
end

return M
