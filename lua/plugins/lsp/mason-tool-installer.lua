local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
}

M.config = function()
  require("mason-tool-installer").setup {
    ensure_installed = {},
    auto_update = true,
    start_delay = 3000,
    debounce_hours = 5,
  }
end

return M
