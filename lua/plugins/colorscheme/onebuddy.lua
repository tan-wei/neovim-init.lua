local M = {
  "Th3Whit3Wolf/onebuddy",
  dependencies = {
    "tjdevries/colorbuddy.vim"
  }
}

M.init = function()
  vim.g.molokai_original = 0
  vim.g.rehash256 = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "onebuddy")
  vim.g.available_colorschemes = available_colorschemes
end

return M
