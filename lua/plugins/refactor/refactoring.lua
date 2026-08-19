---@type LazyPluginSpec
local M = {
  "ThePrimeagen/refactoring.nvim",
  cmd = "Refactor",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("refactoring").setup {
    -- overriding printf statement for cpp
    print_var_statements = {
      -- add a custom print var statement for cpp
      cpp = {
        'printf("a custom statement %%s %s", %s)',
      },
    },
  }
end

return M
