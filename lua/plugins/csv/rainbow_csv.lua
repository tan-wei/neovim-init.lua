local M = {
  "mechatroner/rainbow_csv",
  ft = "csv",
}

M.config = function()
  vim.g.rcsv_colorpairs = {
    { "red", "red" },
    { "blue", "blue" },
    { "green", "green" },
    { "magenta", "magenta" },
    { "NONE", "NONE" },
    { "darkred", "darkred" },
    { "darkblue", "darkblue" },
    { "darkgreen", "darkgreen" },
    { "darkmagenta", "darkmagenta" },
    { "darkcyan", "darkcyan" },
  }
end

return M
