local function get_compile_commands_arg_index(cmd)
  for i, value in ipairs(cmd) do
    if value:find "%-%-compile%-commands%-dir=" then
      return i
    end
  end
end

local function get_compile_commands_dir(cmd)
  local index = get_compile_commands_arg_index(cmd)

  if not index then
    return nil
  end

  return cmd[index]:match "^%-%-compile%-commands%-dir=(.+)$"
end

local function set_compile_commands_dir(cmd, dir)
  local index = get_compile_commands_arg_index(cmd)
  local arg = "--compile-commands-dir=" .. dir

  if index then
    cmd[index] = arg
  else
    table.insert(cmd, arg)
  end
end

local function remove_compile_commands_dir(cmd)
  local index = get_compile_commands_arg_index(cmd)

  if index then
    table.remove(cmd, index)
  end
end

local function normalize_dir(root_dir, dir)
  if not dir or dir == "" or dir:find "%${" then
    return nil
  end

  if vim.fn.fnamemodify(dir, ":p") == dir then
    return vim.fs.normalize(dir)
  end

  return vim.fs.normalize(root_dir .. "/" .. dir)
end

local function has_compile_commands(dir)
  return dir and vim.uv.fs_stat(dir .. "/compile_commands.json") ~= nil
end

local function has_project_compile_config(root_dir)
  local root = vim.fs.normalize(root_dir)
  return vim.uv.fs_stat(root .. "/.clangd") ~= nil or has_compile_commands(root)
end

local function find_compile_commands_dir(root_dir)
  local root = vim.fs.normalize(root_dir)
  local candidates = {
    root,
    root .. "/build",
    root .. "/build/Debug",
    root .. "/build/Release",
    root .. "/build/RelWithDebInfo",
    root .. "/build/MinSizeRel",
  }

  for _, candidate in ipairs(candidates) do
    if has_compile_commands(candidate) then
      return candidate
    end
  end

  local build_root = root .. "/build"
  if vim.uv.fs_stat(build_root) == nil then
    return nil
  end

  local matches = vim.fs.find("compile_commands.json", {
    path = build_root,
    upward = false,
    limit = 1,
    type = "file",
  })

  if #matches == 0 then
    return nil
  end

  return vim.fs.dirname(matches[1])
end

local function clangd_parallelism()
  return "-j=" .. require("util.os").get_parallel_job_count(4, 1)
end

return {
  -- before_init must be at the top level, NOT inside settings.
  -- settings gets JSON-serialized for workspace/didChangeConfiguration,
  -- and functions cannot be serialized.
  before_init = function(_, config)
    local ok, cmake = pcall(require, "cmake-tools")
    if ok then
      cmake.clangd_on_new_config(config)
    end

    if has_project_compile_config(config.root_dir) then
      remove_compile_commands_dir(config.cmd)
      return
    end

    local compile_commands_dir = normalize_dir(config.root_dir, get_compile_commands_dir(config.cmd))
    if has_compile_commands(compile_commands_dir) then
      set_compile_commands_dir(config.cmd, compile_commands_dir)
      return
    end

    local fallback_dir = find_compile_commands_dir(config.root_dir)
    if fallback_dir then
      set_compile_commands_dir(config.cmd, fallback_dir)
      return
    end

    remove_compile_commands_dir(config.cmd)
  end,
  cmd = {
    "clangd",
    "--clang-tidy=false",
    "--background-index",
    "--suggest-missing-includes",
    "--offset-encoding=utf-16",
    clangd_parallelism(),
    "--all-scopes-completion",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--pch-storage=disk",
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
}
