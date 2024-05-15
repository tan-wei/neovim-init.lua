local M = {
  "Mr-LLLLL/cool-chunk.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "CursorHold", "CursorHoldI" },
  enabled = false, -- TODO: hl_group should be set well
}

M.config = function()
  require("cool-chunk").setup {
    context = {
      chars = {
        "",
      },
      hl_group = {
        context = "CursorLineNr",
      },
    },
    line_num = {
      hl_group = {
        chunk = "CursorLineNr",
        context = "LineNr",
        error = "Error",
      },
      fire_event = { "CursorHold", "CursorHoldI" },
    }
  }
end

return M
