local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

M.config = function()
  local harpoon = require "harpoon"
  local extensions = require "harpoon.extensions"

  local function refresh_lualine()
    local ok, lualine = pcall(require, "lualine")
    if ok then
      lualine.refresh { place = { "statusline" } }
    end
  end

  harpoon:setup {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  }

  harpoon:extend(extensions.builtins.highlight_current_file())
  harpoon:extend {
    ADD = refresh_lualine,
    REMOVE = refresh_lualine,
    REPLACE = refresh_lualine,
    SELECT = refresh_lualine,
    REORDER = refresh_lualine,
    LIST_CHANGE = refresh_lualine,
    POSITION_UPDATED = refresh_lualine,
  }
end

return M
