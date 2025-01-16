local M = {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
  cond = false,
}

-- TODO: Add lint progress by require("lint").get_running()
M.config = function()
  local cpp_exist_executables = {}

  if require("util.provider").executable_exist "clang-tidy" then
    table.insert(cpp_exist_executables, "clangtidy")
  end

  if require("util.provider").executable_exist "cppcheck" then
    table.insert(cpp_exist_executables, "cppcheck")
  end

  if require("util.provider").executable_exist "cpplint" then
    table.insert(cpp_exist_executables, "cpplint")
  end

  require("lint").linters_by_ft = {
    cpp = cpp_exist_executables,
  }

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M
