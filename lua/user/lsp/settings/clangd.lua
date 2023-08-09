return {
  cmd = {
    "clangd",
    "--background-index",
    "--compile-commands-dir=build",
    "-j=2",
    "--clang-tidy",
    "--clang-tidy-checks=performance-*,bugprone-*",
    "--all-scopes-completion",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--pch-storage=disk",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  flags = { debounce_text_changes = 150 },
  filetypes = { "c", "cpp", "cxx", "h", "hpp", "objc", "objcpp", "cuda", "proto" },
  single_file_support = true,
}
