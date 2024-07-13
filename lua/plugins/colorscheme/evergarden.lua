local M = {
  "crispybaccoon/evergarden",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "evergarden")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  transparent_background = false,
  contrast_dark = "medium", -- 'hard'|'medium'|'soft'
  override_terminal = true,
  style = {
    tabline = { reverse = true, color = "green" },
    search = { reverse = false, inc_reverse = true },
    types = { italic = true },
    keyword = { italic = true },
    comment = { italic = true },
  },
  overrides = {}, -- add custom overrides
}

return M
