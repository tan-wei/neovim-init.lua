local status_ok, carbon_now = pcall(require, "carbon-now")
if not status_ok then
  return
end

local cmds = {
  Windows_NT = "google",
  Linux = "xdg-open",
  Darwin = "open",
}

carbon_now.setup {
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
