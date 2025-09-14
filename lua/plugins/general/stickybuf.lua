local M = {
  "stevearc/stickybuf.nvim",
  event = "VeryLazy",
}

M.config = function()
  -- TODO: https://github.com/stevearc/stickybuf.nvim/issues/29
  require("stickybuf").setup {
    get_auto_pin = function()
      return false
    end,
  }

  local util = require "stickybuf.util"

  -- NOTE: Do not ignore empty buffer https://github.com/stevearc/stickybuf.nvim/issues/30
  util.is_empty_buffer = function()
    return false
  end
end

return M
