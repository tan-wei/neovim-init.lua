local M = {
  "sam4llis/nvim-tundra",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  -- table.insert(available_colorschemes, "tundra") -- buggy
  vim.g.available_colorschemes = available_colorschemes
end

return M
