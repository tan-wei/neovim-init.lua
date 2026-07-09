---@type LazyPluginSpec
local M = {
  "mechatroner/rainbow_csv",
  ft = { "csv", "tsv" },
}

M.config = function()
  -- By linking to csvColN directly, any colorscheme customizations to those
  -- groups are automatically reflected in rainbow_csv as well.
  vim.g.rcsv_colorlinks = {
    "csvCol1",
    "csvCol2",
    "csvCol3",
    "csvCol4",
    "csvCol5",
    "csvCol6",
    "csvCol7",
    "csvCol8",
    "NONE",
    "Title",
  }
end

return M
