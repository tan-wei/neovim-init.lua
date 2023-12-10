local M = {
  "sindrets/winshift.nvim",
  cmd = { "WinShift" },
}

M.init = function() end

M.config = function()
  require("winshift").setup {
    focused_hl_group = "Visual",
    window_picker = function()
      return require("winshift.lib").pick_window {
        picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        filter_rules = {
          cur_win = true,
          floats = true,
          filetype = { "NvimTree", "alpha" },
          buftype = { "nofile", "terminal", "quickfix" },
        },
        filter_func = nil,
      }
    end,
  }
end

return M
