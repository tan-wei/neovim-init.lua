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
  filetypes = { "c", "cpp", "cxx", "h", "hpp", "objc", "objcpp", "cuda", "proto" },
  single_file_support = true,
}
