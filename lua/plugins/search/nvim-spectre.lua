local M = {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Spectre",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("spectre").setup {
    live_update = false,
    mappings = {},
  }
end

return M
