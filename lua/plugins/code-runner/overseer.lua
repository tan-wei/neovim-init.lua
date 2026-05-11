local M = {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
}

-- Third-party integrations are split across plugin configs:
-- lualine in lua/plugins/ui/lualine.lua,
-- neotest consumer in lua/plugins/test/neotest.lua and templates in lua/user/overseer/template/neotest.lua,
-- auto-session persistence in lua/plugins/project/auto-session.lua.
M.config = function()
  local overseer = require "overseer"

  overseer.setup {
    disable_template_modules = {
      "overseer.template.just",
    },
  }

  overseer.register_template(require "user.overseer.template.cmake_tools")
  overseer.register_template(require "user.overseer.template.just")
  overseer.register_template(require "user.overseer.template.neotest")
  overseer.register_template(require "user.overseer.template.run_script")
end

return M
