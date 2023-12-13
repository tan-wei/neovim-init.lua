local M = {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
}

M.config = function()
  local cmds = {
    Windows_NT = "google",
    Linux = "xdg-open",
    Darwin = "open",
  }

  require("carbon-now").setup {
    open_cmd = cmds[vim.uv.os_uname().sysname],
    options = {
      bg = "gray",
      drop_shadow_blur = "68px",
      drop_shadow = false,
      drop_shadow_offset_y = "20px",
      font_family = "Hack",
      font_size = "18px",
      line_height = "133%",
      line_numbers = true,
      theme = "monokai",
      titlebar = "Made with carbon-now.nvim",
      watermark = false,
      width = "680",
      window_theme = "sharp",
    },
  }
end

return M
