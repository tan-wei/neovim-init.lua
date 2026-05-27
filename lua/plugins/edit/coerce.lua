---@type LazyPluginSpec
local M = {
  "gregorias/coerce.nvim",
  event = "VeryLazy",
  dependencies = {
    "gregorias/coop.nvim",
  },
}

M.config = function()
  require("coerce").setup()

  -- Set up keymaps with which-key
  local ok, wk = pcall(require, "which-key")
  if ok then
    local wke = require("coerce.keymaps").which_key_expand
    wk.add {
      { "cr", group = "+Coerce word", expand = wke.normal_mode, mode = "n" },
      { "gcr", group = "+Coerce motion", expand = wke.motion_mode, mode = "n" },
      { "gcr", group = "+Coerce visual", expand = wke.visual_mode, mode = "x" },
    }
  else
    vim.keymap.set("n", "cr", "<Plug>(coerce-normal)", { desc = "Coerce word" })
    vim.keymap.set("n", "gcr", "<Plug>(coerce-motion)", { desc = "Coerce motion" })
    vim.keymap.set("x", "gcr", "<Plug>(coerce-visual)", { desc = "Coerce visual" })
  end
end

return M
