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
  plugin_strategy = "lazy",
  plugins = vim.g.available_colorschemes,
  colorschemes = vim.g.available_colorschemes,
}

-- local change_color = vim.fn["ChangeColour"]
--
-- if not change_color then
--   local colorscheme = "default"
--
--   local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
--   if not status_ok then
--     return
--   end
-- end
--
-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. "default")
--
-- if not status_ok then
--   return
-- end
