local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
}

M.config = function()
  require("mason-tool-installer").setup {
    ensure_installed = {
      "black",
      "cpplint",
      "shfmt",
    },
    auto_update = true,
    start_delay = 3000,
    debounce_hours = 5,
  }
end

return M
