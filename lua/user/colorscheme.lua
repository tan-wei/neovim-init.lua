local status_ok, colorscheme_randomizer = pcall(require, "colorscheme-randomizer")

if not status_ok then
  local colorscheme = "tokyonight"

  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    return
  end
end

colorscheme_randomizer.setup {
  apply_scheme = true,
  plugin_strategy = nil,
  plugins = nil,
  colorschemes = { "tokyonight" },
  exclude_colorschemes = nil,
}
