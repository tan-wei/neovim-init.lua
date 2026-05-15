local M = {
  "gbprod/yanky.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

-- TODO: Integerate with other plugins

M.config = function()
  local yanky = require "yanky"
  local yanky_utils = require "yanky.utils"

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
    },
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 1000,
    },
  }

  require("telescope").load_extension "yank_history"
end

return M
