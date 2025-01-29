local M = {
  "artemave/workspace-diagnostics.nvim",
  event = "LspAttach",
}

M.config = function()
  require("workspace-diagnostics").setup()
end

return M
