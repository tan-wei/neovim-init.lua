local M = {
  "gregorias/toggle.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  local toggle = require "toggle"

  toggle.setup {
    keymaps = {
      toggle_option_prefix = "yo",
      previous_option_prefix = "[o",
      next_option_prefix = "]o",
      status_dashboard = "yos",
    },
    keymap_registry = require("toggle.keymap").keymap_registry(),
    notify_on_set_default_option = true,
  }

  -- Toggle pin buffer (vim-early-retirement: ignore_early_retirement)
  toggle.register(
    "p",
    toggle.option.NotifyOnSetOption(toggle.option.OnOffOption {
      name = "pin buffer",
      get_state = function()
        local ok, val = pcall(vim.api.nvim_buf_get_var, 0, "ignore_early_retirement")
        return ok and val or false
      end,
      set_state = function(new_value)
        vim.api.nvim_buf_set_var(0, "ignore_early_retirement", new_value)
      end,
    })
  )
end

return M
