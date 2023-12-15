local M = {
  "Badhi/nvim-treesitter-cpp-tools",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "TSCppDefineClassFunc", "TSCppMakeConcreteClass", "TSCppRuleOf3", "TSCppRuleOf5" },
}

M.config = function()
  require("nt-cpp-tools").setup()
end

return M
