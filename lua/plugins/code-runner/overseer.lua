local M = {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
}

-- TODO: Conifgure for several third-party integrations, such as lualine, neotest, toggleterm, session
M.config = function()
  local overseer = require "overseer"

  overseer.register_template(require "user.overseer.template.run_script")

  overseer.setup()
end

return M
