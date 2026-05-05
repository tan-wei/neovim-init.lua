local M = {
  "aperezdc/vim-template",
  cmd = { "Template", "TemplateHere" },
}

local guard_root_names = {
  include = true,
  src = true,
}

local function sanitize_guard_part(value)
  local guard = value:gsub("[^%w]", "_"):gsub("_+", "_"):gsub("^_+", ""):gsub("_+$", "")

  if guard == "" then
    return "UNTITLED"
  end

  if guard:match "^[0-9]" then
    guard = "PROJECT_" .. guard
  end

  return guard:upper()
end

local function normalize_path(path)
  return vim.fs.normalize(path):gsub("/+$", "")
end

local function get_header_guard_prefix()
  local configured_prefix = vim.g.templates_guard_prefix
  if type(configured_prefix) == "string" and configured_prefix ~= "" then
    return sanitize_guard_part(configured_prefix)
  end

  local cwd_name = vim.fs.basename(vim.fn.getcwd())
  if cwd_name and cwd_name ~= "" then
    return sanitize_guard_part(cwd_name)
  end

  return "PROJECT"
end

local function get_relative_path(base_dir, file_path)
  if type(vim.fs.relpath) == "function" then
    local relative_path = vim.fs.relpath(base_dir, file_path)
    if relative_path and relative_path ~= "" then
      return relative_path
    end
  end

  local prefix = normalize_path(base_dir) .. "/"

  if file_path:sub(1, #prefix) == prefix then
    return file_path:sub(#prefix + 1)
  end

  return vim.fs.basename(file_path)
end

local function find_guard_base_dir(file_path)
  local cwd = normalize_path(vim.fn.getcwd())
  local current = normalize_path(vim.fs.dirname(file_path))

  while current and current ~= "" do
    if guard_root_names[vim.fs.basename(current)] then
      return current
    end

    if current == cwd then
      return current
    end

    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      break
    end

    current = normalize_path(parent)
  end

  return cwd
end

function M.build_header_guard_from_prefix_and_path()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then
    return "UNTITLED_HEADER_GUARD"
  end

  local base_dir = find_guard_base_dir(file_path)
  local relative_path = get_relative_path(base_dir, normalize_path(file_path))

  return sanitize_guard_part(get_header_guard_prefix() .. "_" .. relative_path)
end

M.init = function()
  vim.g.templates_no_autocmd = 0
  vim.g.templates_directory = { vim.fn.stdpath "config" .. "/templates/vim-template/" }
  vim.g.templates_name_prefix = ".vim-template:"
  vim.g.templates_global_name_prefix = "=template="
  vim.g.templates_no_builtin_templates = 0

  vim.cmd [[
    function! GetHeaderGuardFromPrefixAndPath() abort
      return luaeval("require('plugins.edit.vim-template').build_header_guard_from_prefix_and_path()")
    endfunction
  ]]

  vim.g.templates_user_variables = {
    { "HEADER_GUARD_FROM_PREFIX_AND_PATH", "GetHeaderGuardFromPrefixAndPath" },
  }
  vim.g.templates_use_licensee = 0
end

return M
