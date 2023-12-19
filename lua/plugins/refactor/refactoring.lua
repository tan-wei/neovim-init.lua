local M = {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
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
  require("telescope").load_extension "refactoring"
end

return M
