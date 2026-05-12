local M = {}

local project_root_markers = {
  ".clangd",
  "compile_commands.json",
  "compile_flags.txt",
  "CMakeLists.txt",
  ".git",
}

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function get_upvalue(fn, target)
  if type(fn) ~= "function" then
    return nil
  end

  for index = 1, 20 do
    local name, value = debug.getupvalue(fn, index)
    if not name then
      return nil
    end

    if name == target then
      return value
    end
  end

  return nil
end

local function get_session_cache_dir()
  if require("util.os").is_windows() then
    return vim.fn.expand "~" .. "/AppData/Local/cmake_tools_nvim/"
  end

  return vim.fn.expand "~" .. "/.cache/cmake_tools_nvim/"
end

local function get_session_path(root_dir)
  local clean_path = root_dir:gsub("/", "")
  clean_path = clean_path:gsub("\\", "")
  clean_path = clean_path:gsub(":", "")
  return get_session_cache_dir() .. clean_path .. ".lua"
end

local function get_path_filename(path)
  if type(path) == "table" and type(path.filename) == "string" then
    return path.filename
  end

  if type(path) == "string" then
    return path
  end

  return nil
end

local function get_active_cmake_build_dir(root_dir)
  local ok, cmake = pcall(require, "cmake-tools")
  if not ok then
    return nil
  end

  local config = get_upvalue(cmake.select_cwd, "config")
  if type(config) ~= "table" then
    return nil
  end

  local config_root = normalize_path(config.cwd)
  if config_root ~= root_dir then
    return nil
  end

  local build_dir = get_path_filename(config.build_directory)
  if build_dir then
    return normalize_path(build_dir)
  end

  if type(config.build_directory_path) == "function" then
    local ok_path, value = pcall(config.build_directory_path, config)
    if ok_path then
      return normalize_path(value)
    end
  end

  return nil
end

local function get_cached_cmake_build_dir(root_dir)
  local session_path = get_session_path(root_dir)
  if vim.uv.fs_stat(session_path) == nil then
    return nil
  end

  local ok, session = pcall(dofile, session_path)
  if not ok or type(session) ~= "table" then
    return nil
  end

  return normalize_path(session.build_directory)
end

local function collect_candidate_dirs(root_dir)
  local candidates = {}
  local seen = {}

  local function add(path)
    local normalized = normalize_path(path)
    if normalized and not seen[normalized] then
      seen[normalized] = true
      table.insert(candidates, normalized)
    end
  end

  add(root_dir)
  add(get_active_cmake_build_dir(root_dir))
  add(get_cached_cmake_build_dir(root_dir))
  add(root_dir .. "/build")
  add(root_dir .. "/build/Debug")
  add(root_dir .. "/build/Release")
  add(root_dir .. "/build/RelWithDebInfo")
  add(root_dir .. "/build/MinSizeRel")
  add(root_dir .. "/out")
  add(root_dir .. "/out/Debug")
  add(root_dir .. "/out/Release")
  add(root_dir .. "/out/RelWithDebInfo")
  add(root_dir .. "/out/MinSizeRel")

  return candidates
end

M.find_project_root = function(file_path)
  local normalized = normalize_path(file_path)
  if not normalized then
    return nil
  end

  return vim.fs.root(normalized, project_root_markers)
end

M.has_compile_commands = function(dir)
  return dir and vim.uv.fs_stat(dir .. "/compile_commands.json") ~= nil
end

M.find_compile_commands_dir = function(root_dir)
  local normalized_root = normalize_path(root_dir)
  if not normalized_root then
    return nil
  end

  for _, candidate in ipairs(collect_candidate_dirs(normalized_root)) do
    if M.has_compile_commands(candidate) then
      return candidate
    end
  end

  for _, search_root in ipairs { normalized_root .. "/build", normalized_root .. "/out" } do
    if vim.uv.fs_stat(search_root) ~= nil then
      local matches = vim.fs.find("compile_commands.json", {
        path = search_root,
        upward = false,
        limit = 1,
        type = "file",
      })

      if #matches > 0 then
        return vim.fs.dirname(matches[1])
      end
    end
  end

  return nil
end

return M
