local compile_commands = require "util.compile_commands"

---@type table<string, any>
local M = {}

local loaded_clients = {}
local detected_filetypes = {}
local dont_cache_extensions = {
  conf = true,
}

local skip_extensions = {
  zst = true,
  gz = true,
  bz2 = true,
  xz = true,
  lzma = true,
  zip = true,
  ["7z"] = true,
  rar = true,
  tar = true,
}

local skip_path_fragments = {
  "/.git/",
  "/.cache/",
  "/build/",
  "/cmake-build/",
  "/node_modules/",
  "/vendor/",
  "/third_party/",
  "/third-party/",
  "/deps/",
  "/.deps/",
}

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function has_cpp_workspace_config(root)
  local normalized_root = normalize_path(root)
  if not normalized_root then
    return false
  end

  return vim.uv.fs_stat(normalized_root .. "/.clangd") ~= nil
    or vim.uv.fs_stat(normalized_root .. "/compile_flags.txt") ~= nil
    or compile_commands.find_compile_commands_dir(normalized_root) ~= nil
end

local function get_workspace_root(client, bufnr)
  local current = normalize_path(vim.api.nvim_buf_get_name(bufnr))
  local client_root = normalize_path(client.config.root_dir)

  if client.name == "clangd" or client.name == "ccls" then
    local project_root = compile_commands.find_project_root(current)
    if has_cpp_workspace_config(project_root) then
      return project_root
    end

    if has_cpp_workspace_config(client_root) then
      return client_root
    end

    return nil
  end

  return client_root or (current and vim.fs.dirname(current)) or normalize_path(vim.uv.cwd())
end

local function get_git_root(root)
  if not root then
    return nil
  end

  local output = vim.fn.systemlist { "git", "-C", root, "rev-parse", "--show-toplevel" }
  if vim.v.shell_error ~= 0 or type(output[1]) ~= "string" or output[1] == "" then
    return nil
  end

  return normalize_path(output[1])
end

local function get_workspace_files(root)
  local git_root = get_git_root(root)
  if not git_root then
    return {}
  end

  local max_size = 1.5 * 1024 * 1024
  local max_files = 250
  local snacks_ok, snacks = pcall(require, "snacks")
  if snacks_ok and snacks.config and snacks.config.get then
    local bigfile = snacks.config.get("bigfile", { size = max_size })
    if type(bigfile) == "table" and type(bigfile.size) == "number" and bigfile.size > 0 then
      max_size = bigfile.size
    end
  end

  local files = vim.fn.systemlist { "git", "-C", root, "ls-files", "--full-name", "--", "." }
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local function is_binary(path)
    local fd = vim.uv.fs_open(path, "r", 438)
    if not fd then
      return false
    end

    local chunk = vim.uv.fs_read(fd, 2048, 0)
    vim.uv.fs_close(fd)
    return type(chunk) == "string" and chunk:find("\0", 1, true) ~= nil
  end

  local candidates = vim.tbl_filter(function(path)
    if path == "" then
      return false
    end

    local fullpath = normalize_path(git_root .. "/" .. path)
    if not fullpath or fullpath:sub(1, #root) ~= root then
      return false
    end

    local normalized = "/" .. path:gsub("\\", "/")
    for _, fragment in ipairs(skip_path_fragments) do
      if normalized:find(fragment, 1, true) then
        return false
      end
    end

    if vim.fn.filereadable(fullpath) ~= 1 then
      return false
    end

    local ext = vim.fn.fnamemodify(path, ":e"):lower()
    if skip_extensions[ext] then
      return false
    end

    local stat = vim.uv.fs_stat(fullpath)
    if stat and stat.type == "file" and stat.size and stat.size > max_size then
      return false
    end

    if is_binary(fullpath) then
      return false
    end

    return true
  end, files)

  if #candidates > max_files then
    table.sort(candidates, function(a, b)
      local a_path = git_root .. "/" .. a
      local b_path = git_root .. "/" .. b
      local a_stat = vim.uv.fs_stat(a_path)
      local b_stat = vim.uv.fs_stat(b_path)
      local a_size = (a_stat and a_stat.size) or math.huge
      local b_size = (b_stat and b_stat.size) or math.huge
      return a_size < b_size
    end)
    candidates = vim.list_slice(candidates, 1, max_files)
  end

  return vim.tbl_map(function(path)
    return normalize_path(git_root .. "/" .. path)
  end, candidates)
end

local function detect_filetype(path)
  local filetype = vim.filetype.match { filename = path }

  if not filetype then
    for _, buf in ipairs(vim.fn.getbufinfo()) do
      if normalize_path(buf.name) == path then
        return vim.filetype.match { buf = buf.bufnr }
      end
    end

    local bufnr = vim.fn.bufadd(path)
    vim.fn.bufload(bufnr)
    filetype = vim.filetype.match { buf = bufnr }
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  return filetype
end

local function get_filetype(path)
  local ext = vim.fn.fnamemodify(path, ":e")

  if rawget(detected_filetypes, ext) ~= nil then
    return detected_filetypes[ext]
  end

  local filetype = detect_filetype(path)

  if not dont_cache_extensions[ext] then
    detected_filetypes[ext] = filetype or false
  end

  return filetype
end

function M.populate_workspace_diagnostics(client, bufnr)
  if loaded_clients[client.id] then
    return
  end

  loaded_clients[client.id] = true

  if not client:supports_method "textDocumentSync/openClose" then
    return
  end

  local filetypes = client.config.filetypes
  if type(filetypes) ~= "table" or vim.tbl_isempty(filetypes) then
    return
  end

  local root = get_workspace_root(client, bufnr)
  if not root then
    return
  end

  local current = normalize_path(vim.api.nvim_buf_get_name(bufnr))
  local workspace_files = get_workspace_files(root)

  for _, path in ipairs(workspace_files) do
    if path ~= current then
      local filetype = get_filetype(path)
      if filetype and vim.tbl_contains(filetypes, filetype) then
        vim.defer_fn(function()
          if not vim.lsp.get_client_by_id(client.id) then
            return
          end

          local params = {
            textDocument = {
              uri = vim.uri_from_fname(path),
              version = 0,
              text = vim.fn.join(vim.fn.readfile(path), "\n"),
              languageId = filetype,
            },
          }

          client:notify("textDocument/didOpen", params)
        end, 0)
      end
    end
  end
end

return M
