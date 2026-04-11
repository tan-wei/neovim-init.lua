local M = {
  "Aejkatappaja/sora",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "sora")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  transparent = false,
  italic_comments = true,

  on_colors = function(colors) end,

  on_highlights = function(hl, colors) end,
}

return M
