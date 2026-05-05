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

  local candidates = {
    normalized_root,
    normalized_root .. "/build",
    normalized_root .. "/build/Debug",
    normalized_root .. "/build/Release",
    normalized_root .. "/build/RelWithDebInfo",
    normalized_root .. "/build/MinSizeRel",
  }

  for _, candidate in ipairs(candidates) do
    if M.has_compile_commands(candidate) then
      return candidate
    end
  end

  local build_root = normalized_root .. "/build"
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

return M
