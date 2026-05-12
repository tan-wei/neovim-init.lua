local M = {}

local state = {
  active_root = nil,
  prompted_scan_base = nil,
}

local preferred_roots_cache = nil

local config = {
  ignored_path_patterns = {
    "/.git/",
    "/.cache/",
    "/build/",
    "/out/",
    "/node_modules/",
  },
  entry_filters = {
    enabled = true,
    exclude_path_patterns = {
      "/vendor/",
      "/third_party/",
      "/third-party/",
      "/_deps/",
      "/deps/",
      "/vcpkg_installed/",
    },
  },
}

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
      return {
        index = index,
        value = value,
      }
    end
  end

  return nil
end

local function get_cmake_state()
  local ok, cmake = pcall(require, "cmake-tools")
  if not ok then
    return nil
  end

  local select_config = get_upvalue(cmake.select_cwd, "config")
  local register_config = get_upvalue(cmake.register_autocmd, "config")
  local register_cwd = get_upvalue(cmake.register_autocmd, "cwd")
  local register_session = get_upvalue(cmake.register_autocmd, "_session")
  local register_config_ctor = get_upvalue(cmake.register_autocmd, "Config")
  local register_const = get_upvalue(cmake.register_autocmd, "const")

  if not select_config or not register_config or not register_cwd or not register_session then
    return nil
  end

  return {
    cmake = cmake,
    select_config = select_config,
    register_config = register_config,
    register_cwd = register_cwd,
    session = register_session.value,
    Config = register_config_ctor and register_config_ctor.value or nil,
    const = register_const and register_const.value or nil,
  }
end

local function sync_cmake_tools_root(root)
  local cmake_state = get_cmake_state()
  if not cmake_state or not cmake_state.Config or not cmake_state.const then
    return false
  end

  local previous_config = cmake_state.select_config.value
  local previous_cwd = cmake_state.register_cwd.value
  if previous_cwd == root and previous_config and previous_config.cwd == root then
    state.active_root = root
    return false
  end

  if previous_config and previous_cwd and previous_cwd ~= "" then
    cmake_state.session.save(previous_cwd, previous_config)
  end

  local next_config = cmake_state.Config:new(cmake_state.const)
  next_config.cwd = root
  next_config = cmake_state.session.update(next_config, cmake_state.session.load(root))

  debug.setupvalue(cmake_state.cmake.select_cwd, cmake_state.select_config.index, next_config)
  debug.setupvalue(cmake_state.cmake.register_autocmd, cmake_state.register_config.index, next_config)
  debug.setupvalue(cmake_state.cmake.register_autocmd, cmake_state.register_cwd.index, root)

  cmake_state.cmake.register_autocmd()
  cmake_state.cmake.register_autocmd_provided_by_users()
  cmake_state.cmake.register_scratch_buffer(next_config.executor.name, next_config.runner.name)

  state.active_root = root
  return true
end

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function path_matches_patterns(path, patterns)
  local normalized = normalize_path(path)
  if not normalized then
    return false
  end

  for _, pattern in ipairs(patterns or {}) do
    if normalized:find(pattern, 1, true) then
      return true
    end
  end

  return false
end

local function get_preferred_roots_path()
  return vim.fs.joinpath(vim.fn.stdpath "data", "cmake-tools", "preferred-roots.json")
end

local function read_preferred_roots()
  if preferred_roots_cache then
    return preferred_roots_cache
  end

  local path = get_preferred_roots_path()
  if vim.uv.fs_stat(path) == nil then
    preferred_roots_cache = {}
    return preferred_roots_cache
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    preferred_roots_cache = {}
    return preferred_roots_cache
  end

  local content = table.concat(lines, "\n")
  if vim.trim(content) == "" then
    preferred_roots_cache = {}
    return preferred_roots_cache
  end

  local decoded_ok, decoded = pcall(vim.json.decode, content)
  if not decoded_ok or type(decoded) ~= "table" then
    preferred_roots_cache = {}
    return preferred_roots_cache
  end

  preferred_roots_cache = decoded
  return preferred_roots_cache
end

local function write_preferred_roots(preferred_roots)
  local path = get_preferred_roots_path()
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ vim.json.encode(preferred_roots) }, path)
  preferred_roots_cache = preferred_roots
end

local function as_directory(path)
  local normalized = normalize_path(path)
  if not normalized then
    return nil
  end

  local stat = vim.uv.fs_stat(normalized)
  if stat and stat.type == "directory" then
    return normalized
  end

  return vim.fs.dirname(normalized)
end

local function path_is_within(path, parent)
  local normalized_path = normalize_path(path)
  local normalized_parent = normalize_path(parent)
  if not normalized_path or not normalized_parent then
    return false
  end

  return normalized_path == normalized_parent
    or normalized_path:sub(1, #normalized_parent + 1) == normalized_parent .. "/"
end

local function find_scan_base(start_path)
  local start_dir = as_directory(start_path or vim.loop.cwd())
  if not start_dir then
    return normalize_path(vim.loop.cwd())
  end

  local repo_root = vim.fs.root(start_dir, { ".git", ".hg", ".svn" })
  if repo_root then
    return normalize_path(repo_root)
  end

  local current = start_dir
  local outermost_cmake_root = nil
  while current and current ~= "" do
    if vim.uv.fs_stat(vim.fs.joinpath(current, "CMakeLists.txt")) ~= nil then
      outermost_cmake_root = current
    end

    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      break
    end

    current = parent
  end

  if outermost_cmake_root then
    return normalize_path(outermost_cmake_root)
  end

  return start_dir
end

local function relative_to_base(path, base)
  local normalized_path = normalize_path(path)
  local normalized_base = normalize_path(base)
  if not normalized_path or not normalized_base then
    return path
  end

  if normalized_path == normalized_base then
    return "."
  end

  if path_is_within(normalized_path, normalized_base) then
    return normalized_path:sub(#normalized_base + 2)
  end

  return normalized_path
end

local function has_cmake_lists(dir)
  local normalized = normalize_path(dir)
  if not normalized then
    return false
  end

  return vim.uv.fs_stat(vim.fs.joinpath(normalized, "CMakeLists.txt")) ~= nil
end

local function collect_ancestor_roots(start_path, stop_dir)
  local path = normalize_path(start_path)
  if not path then
    return {}
  end

  local current = vim.uv.fs_stat(path) and vim.uv.fs_stat(path).type == "directory" and path or vim.fs.dirname(path)
  local roots = {}

  while current and current ~= "" do
    if has_cmake_lists(current) then
      table.insert(roots, current)
    end

    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      break
    end

    if stop_dir and not path_is_within(parent, stop_dir) then
      break
    end

    current = parent
  end

  return roots
end

local function prune_nested_roots(roots)
  local sorted = vim.deepcopy(roots)
  table.sort(sorted, function(left, right)
    if #left ~= #right then
      return #left < #right
    end

    return left < right
  end)

  local results = {}
  for _, root in ipairs(sorted) do
    local nested = false
    for _, kept in ipairs(results) do
      if path_is_within(root, kept) then
        nested = true
        break
      end
    end

    if not nested then
      table.insert(results, root)
    end
  end

  table.sort(results)
  return results
end

local function sort_scan_entries(entries)
  table.sort(entries, function(left, right)
    local left_relative = left.relative or left.cmake_lists or left.root or ""
    local right_relative = right.relative or right.cmake_lists or right.root or ""
    local _, left_depth = left_relative:gsub("/", "/")
    local _, right_depth = right_relative:gsub("/", "/")

    if left_depth ~= right_depth then
      return left_depth < right_depth
    end

    return left_relative < right_relative
  end)
end

local function is_ignored_cmake_file(path)
  local normalized = normalize_path(path)
  if not normalized then
    return true
  end

  if path_matches_patterns(normalized, config.ignored_path_patterns) then
    return true
  end

  return normalized:find "/cmake%-build[%w%-_]*/" ~= nil
end

local function is_filtered_entry(entry)
  if config.entry_filters.enabled == false then
    return false
  end

  if path_matches_patterns(entry.cmake_lists, config.entry_filters.exclude_path_patterns) then
    return true
  end

  if path_matches_patterns(entry.root, config.entry_filters.exclude_path_patterns) then
    return true
  end

  return false
end

local function get_buffer_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end

  return normalize_path(name)
end

function M.find_root(start_path)
  local stop_dir = find_scan_base(start_path)
  local roots = collect_ancestor_roots(start_path, stop_dir)
  return roots[#roots]
end

function M.get_active_root()
  return state.active_root
end

function M.get_scan_base(start_path)
  return find_scan_base(start_path)
end

function M.get_preferred_root(start_path)
  local scan_base = find_scan_base(start_path or vim.loop.cwd())
  if not scan_base then
    return nil
  end

  local preferred_root = read_preferred_roots()[scan_base]
  local normalized = normalize_path(preferred_root)
  if not normalized or not has_cmake_lists(normalized) or not path_is_within(normalized, scan_base) then
    return nil
  end

  return normalized, scan_base
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
end

function M.scan_entries(start_dir, opts)
  opts = opts or {}
  local base_dir = find_scan_base(start_dir or vim.loop.cwd())
  if not base_dir then
    return {}
  end

  local matches = vim.fs.find("CMakeLists.txt", {
    path = base_dir,
    upward = false,
    limit = 10000,
    type = "file",
  })

  local seen = {}
  local entries = {}
  for _, match in ipairs(matches) do
    if not is_ignored_cmake_file(match) then
      local cmake_lists = normalize_path(match)
      local root = cmake_lists and vim.fs.dirname(cmake_lists) or nil
      if cmake_lists and root and not seen[cmake_lists] then
        seen[cmake_lists] = true
        local entry = {
          root = root,
          cmake_lists = cmake_lists,
          scan_base = base_dir,
          relative = relative_to_base(cmake_lists, base_dir),
          root_relative = relative_to_base(root, base_dir),
        }

        if opts.apply_filters == false or not is_filtered_entry(entry) then
          table.insert(entries, entry)
        end
      end
    end
  end

  sort_scan_entries(entries)
  return entries
end

function M.scan_cmake_lists(start_dir)
  local results = {}
  for _, entry in ipairs(M.scan_entries(start_dir)) do
    table.insert(results, entry.cmake_lists)
  end
  return results
end

function M.scan_roots(start_dir)
  local seen = {}
  local roots = {}
  for _, entry in ipairs(M.scan_entries(start_dir)) do
    local root = entry.root
    if root and not seen[root] then
      seen[root] = true
      table.insert(roots, root)
    end
  end

  return prune_nested_roots(roots)
end

function M.auto_select_single_project(start_dir)
  local roots = M.scan_roots(start_dir)
  if #roots ~= 1 then
    return false
  end

  return M.select_root(roots[1])
end

function M.suggest_root(start_path, opts)
  opts = opts or {}

  local scan_base = find_scan_base(start_path or vim.loop.cwd())
  if not scan_base then
    return false
  end

  local preferred_root = M.get_preferred_root(scan_base)
  if preferred_root then
    local changed = M.select_root(preferred_root)
    if changed and type(opts.on_select) == "function" then
      opts.on_select(preferred_root, { preferred_root })
    end
    return changed
  end

  local roots = M.scan_roots(scan_base)
  if #roots == 0 then
    return false
  end

  if #roots == 1 then
    local changed = M.select_root(roots[1])
    if changed and type(opts.on_select) == "function" then
      opts.on_select(roots[1], roots)
    end
    return changed
  end

  if opts.prompt ~= true then
    return false
  end

  if opts.once ~= false and state.prompted_scan_base == scan_base then
    return false
  end

  state.prompted_scan_base = scan_base

  vim.ui.select(roots, {
    prompt = opts.prompt_text or "Select CMake project root",
  }, function(choice)
    if not choice then
      return
    end

    M.select_root(choice)
    if type(opts.on_select) == "function" then
      opts.on_select(choice, roots)
    end
  end)

  return true
end

function M.select_root(root)
  local normalized = normalize_path(root)
  if not normalized then
    return false
  end

  local scan_base = find_scan_base(normalized)
  local preferred_roots = read_preferred_roots()
  preferred_roots[scan_base] = normalized
  write_preferred_roots(preferred_roots)
  state.prompted_scan_base = scan_base

  if state.active_root == normalized then
    return false
  end

  return sync_cmake_tools_root(normalized)
end

function M.sync_path(path)
  local preferred_root = M.get_preferred_root(path)
  if preferred_root then
    return M.select_root(preferred_root)
  end

  local root = M.find_root(path)
  if not root then
    return false
  end

  return M.select_root(root)
end

function M.sync_buffer(bufnr)
  local buffer = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buffer) then
    return false
  end

  if vim.bo[buffer].buftype ~= "" then
    return false
  end

  local path = get_buffer_path(buffer)
  if not path then
    return false
  end

  return M.sync_path(path)
end

return M
