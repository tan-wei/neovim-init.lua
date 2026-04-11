return {
  -- before_init must be at the top level, NOT inside settings.
  -- settings gets JSON-serialized for workspace/didChangeConfiguration,
  -- and functions cannot be serialized.
  before_init = function(_, config)
    local ok, cmake = pcall(require, "cmake-tools")
    if ok then
      cmake.clangd_on_new_config(config)
    elseif vim.uv.fs_stat(config.root_dir .. "/compile_commands.json") then
      for i, v in ipairs(config.cmd) do
        if v:find "%-%-compile%-commands%-dir=" then
          table.remove(config.cmd, i)
          break
        end
      end
      table.insert(config.cmd, "--compile-commands-dir=" .. config.root_dir)
    end
  end,
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
  },
}
