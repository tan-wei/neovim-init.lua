local M = {
  "zenbones-theme/zenbones.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zenbones")
  table.insert(available_colorschemes, "zenwritten")
  table.insert(available_colorschemes, "vimbones")
  table.insert(available_colorschemes, "rosebones")
  table.insert(available_colorschemes, "forestbones")
  table.insert(available_colorschemes, "nordbones")
  table.insert(available_colorschemes, "tokyobones")
  table.insert(available_colorschemes, "seoulbones")
  table.insert(available_colorschemes, "duckbones")
  table.insert(available_colorschemes, "zenburned")
  table.insert(available_colorschemes, "kanagawabones")

  -- Or use this?
  -- table.insert(available_colorschemes, "randombones")
  vim.g.available_colorschemes = available_colorschemes
end

return M
