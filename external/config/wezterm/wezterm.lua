local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 32
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.automatically_reload_config = true
config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "SteadyBlock"
config.adjust_window_size_when_changing_font_size = false

local platform = "linux"

if wezterm.running_under_wsl() then
  platform = "wsl"
elseif wezterm.target_triple:find "darwin" then
  platform = "macos"
end

local platform_module = dofile(wezterm.config_dir .. "/platform/" .. platform .. ".lua")
platform_module.apply_to_config(config, wezterm)

return config
