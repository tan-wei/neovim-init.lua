return {
  settings = {
    cmd = {
      "clangd",
      "--background-index",
      "--compile-commands-dir=build",
      "--suggest-missing-includes",
      "--offset-encoding=utf-16",
      "-j=2",
      "--clang-tidy",
      "--clang-tidy-checks=performance-*,bugprone-*",
      "--all-scopes-completion",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
      "--pch-storage=disk",
      "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
      "--cross-file-rename",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    flags = { debounce_text_changes = 150 },
    filetypes = { "c", "cpp", "cxx", "h", "hpp", "objc", "objcpp", "cuda", "proto" },
    single_file_support = true,
    -- on_new_config = function(new_config, new_cwd)
    --   local status, cmake = pcall(require, "cmake-tools")
    --   if status then
    --     cmake.clangd_on_new_config(new_config)
    --   end
    -- end,
  },
}
