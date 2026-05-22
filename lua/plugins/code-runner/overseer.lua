---@type LazyPluginSpec
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

  overseer.add_template_hook({ name = "^just " }, function(task_defn, util)
    if type(task_defn.cmd) ~= "table" or task_defn.cmd[1] ~= "just" then
      return
    end

    util.remove_component(task_defn, "on_complete_notify")
    util.add_component(task_defn, { "on_complete_notify", statuses = { "SUCCESS" } }, {
      "on_output_quickfix",
      items_only = true,
      open = false,
      open_on_exit = "never",
      set_diagnostics = true,
      tail = false,
    }, { "on_result_diagnostics_trouble" })
  end)

  overseer.register_template(require "user.overseer.template.cmake_tools")
  overseer.register_template(require "user.overseer.template.just")
  overseer.register_template(require "user.overseer.template.neotest")
  overseer.register_template(require "user.overseer.template.run_script")
end

return M
