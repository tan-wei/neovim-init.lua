local M = {
  "gregorias/toggle.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("toggle").setup {
    keymaps = {
      toggle_option_prefix = "yo",
      previous_option_prefix = "[o",
      next_option_prefix = "]o",
      status_dashboard = "yos",
    },
    keymap_registry = require("toggle.keymap").keymap_registry(),
    notify_on_set_default_option = true,
  }
end

return M
