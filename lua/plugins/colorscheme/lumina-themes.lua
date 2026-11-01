---@type LazyPluginSpec
local M = {
  "RazikSF/lumina-themes",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "lumina-aurora-dark")
  table.insert(available_colorschemes, "lumina-canopy-dark")
  table.insert(available_colorschemes, "lumina-cherenkov-dark")
  table.insert(available_colorschemes, "lumina-dusk-dark")
  table.insert(available_colorschemes, "lumina-ember-dark")
  table.insert(available_colorschemes, "lumina-espresso-dark")
  table.insert(available_colorschemes, "lumina-harbor-dark")
  table.insert(available_colorschemes, "lumina-lagoon-dark")
  table.insert(available_colorschemes, "lumina-nebula-dark")
  table.insert(available_colorschemes, "lumina-olive-dark")
  table.insert(available_colorschemes, "lumina-oxblood-dark")
  table.insert(available_colorschemes, "lumina-parchment-dark")
  table.insert(available_colorschemes, "lumina-polaire-dark")
  table.insert(available_colorschemes, "lumina-quartz-dark")
  table.insert(available_colorschemes, "lumina-rayleigh-dark")
  table.insert(available_colorschemes, "lumina-vitrail-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
