---@type table<string, any>
local M = {}

local cpp_clients = { clangd = true, ccls = true }
local watchers = {}

-- Prevent ccls restarts from leaving duplicate CodeLens virtual lines behind.
local function clear_stale_codelens_namespaces(buffers)
  for name, namespace in pairs(vim.api.nvim_get_namespaces()) do
    local client_id = tonumber(name:match "^nvim%.lsp%.codelens:(%d+)$")
    if client_id and not vim.lsp.get_client_by_id(client_id) then
      for bufnr in pairs(buffers) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
        end
      end
    end
  end
end

M.enable_ccls_codelens = function(client, bufnr)
  clear_stale_codelens_namespaces { [bufnr] = true }
  vim.lsp.codelens.enable(true, { client_id = client.id, bufnr = bufnr })
end

M.restart_clients = function(clients, reason)
  local names = {}
  for _, client in pairs(clients) do
    if vim.lsp.get_client_by_id(client.id) == client then
      names[client.name] = true
      client:_restart(client.exit_timeout)
    end
  end

  if next(names) then
    local restarted = vim.tbl_keys(names)
    table.sort(restarted)
    vim.notify("LSP restarted: " .. table.concat(restarted, ", ") .. " (" .. reason .. ")")
  end
end

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

local function client_root(client)
  return normalize_path(client.config.root_dir or (client.workspace_folders and client.workspace_folders[1].name))
end

local function client_compile_commands_dir(client)
  if client.name == "clangd" then
    for _, arg in ipairs(client.config.cmd or {}) do
      local dir = arg:match "^%-%-compile%-commands%-dir=(.+)$"
      if dir then
        return vim.fs.abspath(dir, { cwd = client_root(client) or vim.uv.cwd() }), "--compile-commands-dir"
      end
    end
  elseif client.name == "ccls" then
    local dir = (client.config.init_options or {}).compilationDatabaseDirectory
    if dir then
      return vim.fs.abspath(dir, { cwd = client_root(client) or vim.uv.cwd() }), "initializationOptions"
    end
  end

  local root = client_root(client)
  return M.find_compile_commands_dir(root), "auto-discovery"
end

local function client_compile_commands_path(client)
  local dir = client_compile_commands_dir(client)
  if not dir then
    return nil
  end

  local path = dir .. "/compile_commands.json"
  return vim.uv.fs_realpath(path) or normalize_path(path)
end

local function clients_for_compile_commands(path)
  local clients = {}
  for _, client in pairs(vim.lsp.get_clients()) do
    if cpp_clients[client.name] and client_compile_commands_path(client) == path then
      clients[client.id] = client
    end
  end
  return clients
end

M.show_info = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = { "compile_commands.json status" }
  local clients = vim.tbl_filter(function(client)
    return cpp_clients[client.name]
  end, vim.lsp.get_clients { bufnr = bufnr })

  if #clients == 0 then
    table.insert(lines, "No clangd/ccls client is attached to this buffer.")
  end

  for _, client in ipairs(clients) do
    local dir, source = client_compile_commands_dir(client)
    local path = dir and (dir .. "/compile_commands.json") or nil
    local exists = path and vim.uv.fs_stat(path) ~= nil
    table.insert(lines, "")
    table.insert(lines, client.name .. " (client " .. client.id .. ")")
    table.insert(lines, "  configured: " .. (path or "none") .. " [" .. source .. "]")
    table.insert(lines, "  database: " .. (exists and "exists" or "missing"))
    table.insert(lines, "  evidence: startup configuration only")
  end

  table.insert(lines, "")
  table.insert(lines, "Note: LSP exposes no query for the database path actually opened by clangd/ccls.")
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Compile Commands" })
end

local function ensure_command()
  if vim.fn.exists ":CompileCommandsInfo" == 2 then
    return
  end
  pcall(vim.api.nvim_del_user_command, "CompileCommandsInfo")
  vim.api.nvim_create_user_command("CompileCommandsInfo", function()
    M.show_info()
  end, { desc = "Show C/C++ compilation database status" })
end

M.attach = function(client)
  if not cpp_clients[client.name] then
    return false
  end

  ensure_command()
  local dir = client_compile_commands_dir(client)
  if not M.has_compile_commands(dir) then
    return false
  end

  local path = vim.uv.fs_realpath(dir .. "/compile_commands.json") or normalize_path(dir .. "/compile_commands.json")
  local watched = watchers[path]
  if watched then
    return false
  end

  local poll = vim.uv.new_fs_poll()
  watched = { poll = poll, debounce = vim.uv.new_timer() }
  local ok = poll:start(
    path,
    1000,
    vim.schedule_wrap(function(err, previous, current)
      if not err and previous and current and watchers[path] == watched then
        watched.debounce:stop()
        watched.debounce:start(
          500,
          0,
          vim.schedule_wrap(function()
            M.restart_clients(clients_for_compile_commands(path), "compile_commands.json changed")
          end)
        )
      end
    end)
  )
  if ok then
    watchers[path] = watched
    return true
  else
    poll:close()
    watched.debounce:close()
    return false
  end
end

return M
