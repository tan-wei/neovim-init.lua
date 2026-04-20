local M = {
  "aymenhafeez/doric-themes.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "doric-copper")
  table.insert(available_colorschemes, "doric-dark")
  table.insert(available_colorschemes, "doric-fire")
  table.insert(available_colorschemes, "doric-mermaid")
  table.insert(available_colorschemes, "doric-obsidian")
  table.insert(available_colorschemes, "doric-pine")
  table.insert(available_colorschemes, "doric-plum")
  table.insert(available_colorschemes, "doric-valley")
  table.insert(available_colorschemes, "doric-water")
  vim.g.available_colorschemes = available_colorschemes
end

return M
