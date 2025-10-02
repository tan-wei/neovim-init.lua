local M = {
  "uhs-robert/oasis.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "oasis-abyss")
  table.insert(available_colorschemes, "oasis-cactus")
  table.insert(available_colorschemes, "oasis-canyon")
  table.insert(available_colorschemes, "oasis-desert")
  table.insert(available_colorschemes, "oasis-dune")
  table.insert(available_colorschemes, "oasis-lagoon")
  table.insert(available_colorschemes, "oasis-mirage")
  table.insert(available_colorschemes, "oasis-night")
  table.insert(available_colorschemes, "oasis-rose")
  table.insert(available_colorschemes, "oasis-sol")
  table.insert(available_colorschemes, "oasis-starlight")
  table.insert(available_colorschemes, "oasis-twilight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
