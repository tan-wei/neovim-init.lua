local uv = vim.uv or vim.loop

if _G.__keymap_audit_state then
  return
end

local function normalize_path(path)
  return path:gsub("\\", "/")
end

local function script_path()
  local source = debug.getinfo(1, "S").source
  if source:sub(1, 1) == "@" then
    return source:sub(2)
  end
  error "Unable to determine script path"
end

local SCRIPT = normalize_path(script_path())
local ROOT = normalize_path(vim.fn.fnamemodify(SCRIPT, ":p:h:h"))
local LUA_PATHS = table.concat({
  ROOT .. "/lua/?.lua",
  ROOT .. "/lua/?/init.lua",
}, ";") .. ";"

if not package.path:find(LUA_PATHS, 1, true) then
  package.path = LUA_PATHS .. package.path
end

vim.opt.runtimepath:prepend(ROOT)
vim.fn.chdir(ROOT)

local state = {
  records = {},
  sequence = 0,
}

_G.__keymap_audit_state = state

local function relpath(path)
  if not path or path == "" then
    return "<unknown>"
  end

  local normalized = normalize_path(path)
  if normalized == SCRIPT then
    return "scripts/keymap_audit.lua"
  end

  local prefix = ROOT .. "/"
  if normalized:sub(1, #prefix) == prefix then
    return normalized:sub(#prefix + 1)
  end

  return normalized
end

local function dedupe(items)
  local seen = {}
  local result = {}
  for _, item in ipairs(items) do
    if item ~= nil and item ~= "" and not seen[item] then
      seen[item] = true
      result[#result + 1] = item
    end
  end
  return result
end

local function normalize_modes(mode)
  local modes = {}

  local function push(value)
    if type(value) ~= "string" then
      return
    end

    if value == "" then
      vim.list_extend(modes, { "n", "v", "o" })
      return
    end

    if value == "!" then
      vim.list_extend(modes, { "i", "c" })
      return
    end

    if #value == 1 then
      modes[#modes + 1] = value
      return
    end

    for index = 1, #value do
      modes[#modes + 1] = value:sub(index, index)
    end
  end

  if type(mode) == "table" then
    for _, item in ipairs(mode) do
      push(item)
    end
  else
    push(mode)
  end

  return dedupe(modes)
end

local function rhs_summary(rhs)
  local rhs_type = type(rhs)
  if rhs_type == "string" then
    local compact = rhs:gsub("%s+", " ")
    if #compact > 96 then
      return compact:sub(1, 93) .. "..."
    end
    return compact
  end

  if rhs_type == "function" then
    return "<lua function>"
  end

  return "<" .. rhs_type .. ">"
end

local function first_repo_frame()
  local fallback

  for level = 3, 24 do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end

    local source = info.source
    if type(source) == "string" and source:sub(1, 1) == "@" then
      source = source:sub(2)
    end

    local relative = relpath(source)
    if relative ~= "scripts/keymap_audit.lua" then
      fallback = fallback or { source = relative, line = info.currentline or 0 }
      if relative:sub(1, 4) ~= "/hom" and relative:sub(1, 1) ~= "[" then
        return relative, info.currentline or 0
      end
      if relative:match "^lua/" or relative:match "^init%.lua$" then
        return relative, info.currentline or 0
      end
    end
  end

  if fallback then
    return fallback.source, fallback.line
  end

  return "<unknown>", 0
end

local function direct_caller_source()
  local info = debug.getinfo(3, "S")
  if not info or type(info.source) ~= "string" then
    return ""
  end

  local source = info.source
  if source:sub(1, 1) == "@" then
    source = source:sub(2)
  end

  return relpath(source)
end

local function push_record(kind, mode, lhs, rhs, opts, extra)
  if type(lhs) ~= "string" or lhs == "" then
    return
  end

  local source, line = first_repo_frame()
  local desc = type(opts) == "table" and opts.desc or nil
  local buffer = extra and extra.buffer or (type(opts) == "table" and opts.buffer) or nil

  for _, normalized_mode in ipairs(normalize_modes(mode)) do
    state.sequence = state.sequence + 1
    state.records[#state.records + 1] = {
      seq = state.sequence,
      kind = kind,
      mode = normalized_mode,
      lhs = lhs,
      rhs = rhs_summary(rhs),
      desc = desc,
      buffer = buffer,
      source = source,
      line = line,
    }
  end
end

local original_keymap_set = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
  push_record("vim.keymap.set", mode, lhs, rhs, opts)
  return original_keymap_set(mode, lhs, rhs, opts)
end

local original_nvim_set_keymap = vim.api.nvim_set_keymap
vim.api.nvim_set_keymap = function(mode, lhs, rhs, opts)
  if direct_caller_source():find("vim/keymap", 1, true) then
    return original_nvim_set_keymap(mode, lhs, rhs, opts)
  end

  push_record("nvim_set_keymap", mode, lhs, rhs, opts)
  return original_nvim_set_keymap(mode, lhs, rhs, opts)
end

local original_nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
vim.api.nvim_buf_set_keymap = function(buffer, mode, lhs, rhs, opts)
  if direct_caller_source():find("vim/keymap", 1, true) then
    return original_nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
  end

  push_record("nvim_buf_set_keymap", mode, lhs, rhs, opts, { buffer = buffer })
  return original_nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
end

local function read_file(path)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then
    return nil
  end

  local stat = uv.fs_fstat(fd)
  if not stat then
    uv.fs_close(fd)
    return nil
  end

  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

local MAPPING_PATTERNS = {
  "vim%.keymap%.set",
  "nvim_set_keymap",
  "nvim_buf_set_keymap",
  "M%.keys%s*=",
  "wk%.add%s*{",
  "open_mapping%s*=",
  "toggle_option_prefix%s*=",
  "previous_option_prefix%s*=",
  "next_option_prefix%s*=",
  "status_dashboard%s*=",
  "fast_wrap%s*=",
}

local function file_may_define_keymaps(contents)
  for _, pattern in ipairs(MAPPING_PATTERNS) do
    if contents:find(pattern) then
      return true
    end
  end
  return false
end

local function discover_mapping_plugins()
  local files = vim.fn.globpath(ROOT .. "/lua/plugins", "**/*.lua", false, true)
  local plugins = {}

  for _, path in ipairs(files) do
    local contents = read_file(path)
    if contents and file_may_define_keymaps(contents) then
      local repo = contents:match 'local%s+M%s*=%s*{%s*"([^"]+)"'
      if repo then
        local name = repo:match "[^/]+$" or repo
        plugins[name] = true
      end
    end
  end

  return plugins
end

local function load_mapping_plugins()
  local ok_lazy, lazy = pcall(require, "lazy")
  local ok_cfg, cfg = pcall(require, "lazy.core.config")
  if not (ok_lazy and ok_cfg) then
    return
  end

  local candidates = discover_mapping_plugins()
  local plugin_names = {}

  for name in pairs(candidates) do
    if cfg.plugins[name] then
      plugin_names[#plugin_names + 1] = name
    end
  end

  table.sort(plugin_names)

  if #plugin_names == 0 then
    return
  end

  local ok, err = pcall(lazy.load, {
    plugins = plugin_names,
    wait = true,
  })
  if not ok then
    io.stderr:write("keymap audit: failed to load mapping plugins\n" .. tostring(err) .. "\n")
    vim.cmd "cquit 2"
  end
end

local function logical_owner_key(record)
  if not record.desc or record.desc == "" then
    return nil
  end

  local scope = record.buffer and ("buffer:" .. tostring(record.buffer)) or "global"
  return table.concat({ scope, record.mode, record.lhs, record.source, record.desc }, "\0")
end

local function record_score(record)
  local score = 0
  if record.source ~= "=[C]" then
    score = score + 2
  end
  if record.rhs ~= "<lua function>" then
    score = score + 1
  end
  return score
end

local function effective_records()
  local result = {}
  local owners = {}

  for _, record in ipairs(state.records) do
    local owner = logical_owner_key(record)
    if not owner then
      result[#result + 1] = record
    else
      local existing = owners[owner]
      if not existing then
        owners[owner] = {
          index = #result + 1,
          record = record,
        }
        result[#result + 1] = record
      elseif record_score(record) > record_score(existing.record) then
        owners[owner].record = record
        result[existing.index] = record
      end
    end
  end

  return result
end

local function entry_identity(mode, lhs, rhs, desc)
  return table.concat({ mode, lhs, rhs or "", desc or "" }, "\0")
end

local function declared_registry_entries()
  local ok, registry = pcall(require, "user.keymap.registry")
  if not ok then
    return {}, { string.format("failed to load registry: %s", registry) }
  end

  local ok_entries, entries = pcall(registry.all_entries)
  if not ok_entries then
    return {}, { string.format("failed to collect registry entries: %s", entries) }
  end

  return entries, {}
end

local function declared_registry_index(entries)
  local index = {}

  for _, entry in ipairs(entries) do
    for _, mode in ipairs(normalize_modes(entry.mode)) do
      local rhs = rhs_summary(entry.rhs)
      local desc = entry.desc or ((type(entry.opts) == "table" and entry.opts.desc) or "")
      local id = entry_identity(mode, entry.lhs, rhs, desc)
      index[id] = index[id] or {}
      index[id][#index[id] + 1] = entry
    end
  end

  return index
end

local function registry_metadata_issues()
  local ok_builtin, builtin = pcall(require, "user.keymap.builtin")
  if not ok_builtin then
    return { string.format("failed to load builtin conflict table: %s", builtin) }
  end

  local entries, errors = declared_registry_entries()
  if #errors > 0 then
    return errors
  end

  local issues = {}
  local expected = builtin.all()

  local function has_conflict_annotation(entry)
    local conflict = type(entry.conflict) == "table" and entry.conflict or nil
    if not conflict then
      return false
    end

    return (type(conflict.builtin) == "string" and conflict.builtin ~= "")
      or (type(conflict.note) == "string" and conflict.note ~= "")
  end

  local function builtin_like_slot_reason(mode, lhs)
    if mode ~= "n" then
      return nil
    end

    local lowered = lhs:lower()
    if lowered:find "^<leader>" or lowered:find "^<localleader>" or lhs:find "^<Plug>" then
      return nil
    end

    if lhs:find "^<C%-w>" then
      return "normal-mode <C-w> family"
    end

    if lhs:find "^g[%a<]" then
      return "normal-mode g family"
    end

    if lhs:find "^z[%a<]" then
      return "normal-mode z family"
    end

    if lhs:find "^[A-Za-z]$" then
      return "normal-mode single-key slot"
    end

    if lhs:find "^<C%-%a>$" then
      return "normal-mode Ctrl-letter slot"
    end

    return nil
  end

  local function symbol_contract(mode, lhs)
    if mode ~= "n" then
      return nil
    end

    if lhs:find "^[%[%]][A-Za-z]$" then
      return {
        family = "bracket",
        namespace = lhs:sub(2, 2),
        direction = lhs:sub(1, 1) == "[" and "prev" or "next",
      }
    end

    if lhs:find "^[><=][A-Za-z]$" then
      return {
        family = "operator",
        namespace = lhs:sub(2, 2),
      }
    end

    return nil
  end

  local function symbol_metadata(entry)
    return type(entry.symbol) == "table" and entry.symbol or nil
  end

  local bracket_motion_pairs = {}

  for _, entry in ipairs(entries) do
    for _, mode in ipairs(normalize_modes(entry.mode)) do
      local expected_builtin = expected[builtin.key(mode, entry.lhs)]
      if expected_builtin then
        local actual = entry.conflict and entry.conflict.builtin or nil
        if actual == nil or actual == "" then
          issues[#issues + 1] = string.format(
            "%s %s in plugin %s is missing conflict.builtin metadata (expected: %s)",
            mode,
            entry.lhs,
            entry.plugin or "<unknown>",
            expected_builtin
          )
        elseif actual ~= expected_builtin then
          issues[#issues + 1] = string.format(
            "%s %s in plugin %s has conflict.builtin=%q but expected %q",
            mode,
            entry.lhs,
            entry.plugin or "<unknown>",
            actual,
            expected_builtin
          )
        end
      else
        local reason = builtin_like_slot_reason(mode, entry.lhs)
        if reason and not has_conflict_annotation(entry) then
          issues[#issues + 1] = string.format(
            "%s %s in plugin %s uses a builtin-like %s and must declare conflict.builtin or conflict.note",
            mode,
            entry.lhs,
            entry.plugin or "<unknown>",
            reason
          )
        end
      end

      local contract = symbol_contract(mode, entry.lhs)
      if contract then
        local symbol = symbol_metadata(entry)
        if not symbol then
          issues[#issues + 1] = string.format(
            "%s %s in plugin %s must declare symbol metadata for the %s family",
            mode,
            entry.lhs,
            entry.plugin or "<unknown>",
            contract.family
          )
        else
          if symbol.family ~= contract.family then
            issues[#issues + 1] = string.format(
              "%s %s in plugin %s has symbol.family=%q but expected %q",
              mode,
              entry.lhs,
              entry.plugin or "<unknown>",
              tostring(symbol.family),
              contract.family
            )
          end

          if symbol.namespace ~= contract.namespace then
            issues[#issues + 1] = string.format(
              "%s %s in plugin %s has symbol.namespace=%q but expected %q",
              mode,
              entry.lhs,
              entry.plugin or "<unknown>",
              tostring(symbol.namespace),
              contract.namespace
            )
          end

          if contract.family == "bracket" then
            if symbol.direction ~= contract.direction then
              issues[#issues + 1] = string.format(
                "%s %s in plugin %s has symbol.direction=%q but expected %q",
                mode,
                entry.lhs,
                entry.plugin or "<unknown>",
                tostring(symbol.direction),
                contract.direction
              )
            end

            if symbol.role ~= "motion" and symbol.role ~= "action" then
              issues[#issues + 1] = string.format(
                "%s %s in plugin %s must set symbol.role to %q or %q",
                mode,
                entry.lhs,
                entry.plugin or "<unknown>",
                "motion",
                "action"
              )
            elseif symbol.role == "motion" then
              if symbol.repeatable ~= true then
                issues[#issues + 1] = string.format(
                  "%s %s in plugin %s is a bracket motion and must set symbol.repeatable=true",
                  mode,
                  entry.lhs,
                  entry.plugin or "<unknown>"
                )
              end

              if symbol.repeat_engine ~= "demicolon" then
                issues[#issues + 1] = string.format(
                  "%s %s in plugin %s is a bracket motion and must set symbol.repeat_engine=%q",
                  mode,
                  entry.lhs,
                  entry.plugin or "<unknown>",
                  "demicolon"
                )
              end

              local pair_id = table.concat({ mode, contract.namespace }, "\0")
              bracket_motion_pairs[pair_id] = bracket_motion_pairs[pair_id]
                or {
                  mode = mode,
                  namespace = contract.namespace,
                  directions = {},
                }
              bracket_motion_pairs[pair_id].directions[contract.direction] = true
            elseif symbol.repeatable ~= false then
              issues[#issues + 1] = string.format(
                "%s %s in plugin %s is a bracket action and must set symbol.repeatable=false",
                mode,
                entry.lhs,
                entry.plugin or "<unknown>"
              )
            end
          elseif contract.family == "operator" then
            if symbol.role ~= "action" then
              issues[#issues + 1] = string.format(
                "%s %s in plugin %s is an operator-family entry and must set symbol.role=%q",
                mode,
                entry.lhs,
                entry.plugin or "<unknown>",
                "action"
              )
            end

            if symbol.repeatable ~= false then
              issues[#issues + 1] = string.format(
                "%s %s in plugin %s is an operator-family entry and must set symbol.repeatable=false",
                mode,
                entry.lhs,
                entry.plugin or "<unknown>"
              )
            end
          end
        end
      end
    end
  end

  for _, pair in pairs(bracket_motion_pairs) do
    if not pair.directions.prev or not pair.directions.next then
      issues[#issues + 1] = string.format(
        "%s [%s/%s] bracket motion namespace %s must define both prev and next mappings",
        pair.mode,
        "[",
        "]",
        pair.namespace
      )
    end
  end

  return issues
end

local function declared_record_location(record, registry_index)
  if not (record.source == "lua/user/keymap/registry.lua" or record.source == "=[C]") then
    return nil
  end

  local id = entry_identity(record.mode, record.lhs, record.rhs, record.desc)
  local matches = registry_index[id]
  if not matches or #matches == 0 then
    return nil
  end

  local entry = matches[1]
  local location = entry.source_file or "<registry>"
  if entry.plugin then
    location = string.format("%s [%s]", location, entry.plugin)
  end
  return location
end

local function group_conflicts()
  local grouped = {}

  for _, record in ipairs(effective_records()) do
    local scope = record.buffer and ("buffer:" .. tostring(record.buffer)) or "global"
    local id = table.concat({ scope, record.mode, record.lhs }, "\0")
    grouped[id] = grouped[id]
      or {
        scope = scope,
        mode = record.mode,
        lhs = record.lhs,
        records = {},
      }
    grouped[id].records[#grouped[id].records + 1] = record
  end

  local conflicts = {}
  for _, group in pairs(grouped) do
    if #group.records > 1 then
      table.sort(group.records, function(left, right)
        return left.seq < right.seq
      end)
      conflicts[#conflicts + 1] = group
    end
  end

  table.sort(conflicts, function(left, right)
    if left.scope ~= right.scope then
      return left.scope < right.scope
    end
    if left.mode ~= right.mode then
      return left.mode < right.mode
    end
    return left.lhs < right.lhs
  end)

  return conflicts
end

local function runtime_winner(mode, lhs)
  local map = vim.fn.maparg(lhs, mode, false, true)
  if type(map) ~= "table" or vim.tbl_isempty(map) then
    return nil
  end

  if map.desc and map.desc ~= "" then
    return map.desc
  end

  if map.rhs and map.rhs ~= "" then
    local compact = map.rhs:gsub("%s+", " ")
    if #compact > 96 then
      return compact:sub(1, 93) .. "..."
    end
    return compact
  end

  if map.callback then
    return "<lua function>"
  end

  return nil
end

local function format_record(record, registry_index)
  local location = declared_record_location(record, registry_index) or record.source
  if record.line and record.line > 0 then
    if location == record.source then
      location = string.format("%s:%d", record.source, record.line)
    end
  end

  local suffix = {}
  if record.desc and record.desc ~= "" then
    suffix[#suffix + 1] = "desc=" .. record.desc
  end
  if record.rhs and record.rhs ~= "" then
    suffix[#suffix + 1] = "rhs=" .. record.rhs
  end
  suffix[#suffix + 1] = "via=" .. record.kind

  return string.format("    - %s (%s)", location, table.concat(suffix, "; "))
end

local function print_report(conflicts, metadata_issues, registry_index)
  print(string.format("keymap audit: recorded %d registrations", #state.records))

  if #conflicts == 0 and #metadata_issues == 0 then
    print "keymap audit: no duplicate repo registrations or keymap metadata issues detected"
    return
  end

  if #conflicts > 0 then
    print(string.format("keymap audit: found %d duplicate lhs registrations", #conflicts))

    for _, conflict in ipairs(conflicts) do
      local winner = conflict.scope == "global" and runtime_winner(conflict.mode, conflict.lhs) or nil
      local header =
        string.format("- [%s] %s %s (%d registrations)", conflict.scope, conflict.mode, conflict.lhs, #conflict.records)
      if winner then
        header = header .. " -> runtime winner: " .. winner
      end
      print(header)
      for _, record in ipairs(conflict.records) do
        print(format_record(record, registry_index))
      end
    end
  end

  if #metadata_issues > 0 then
    print(string.format("keymap audit: found %d keymap metadata issues", #metadata_issues))
    for _, issue in ipairs(metadata_issues) do
      print("    - " .. issue)
    end
  end
end

local function fail_on_conflict()
  local value = vim.env.KEYMAP_AUDIT_FAIL_ON_CONFLICT
  return value == "1" or value == "true" or value == "yes"
end

function _G.__keymap_audit_finalize()
  load_mapping_plugins()

  local conflicts = group_conflicts()
  local entries = declared_registry_entries()
  local registry_entries = entries
  local registry_index = declared_registry_index(registry_entries)
  local metadata_issues = registry_metadata_issues()
  print_report(conflicts, metadata_issues, registry_index)

  if #conflicts > 0 or #metadata_issues > 0 then
    if fail_on_conflict() then
      vim.cmd "cquit 1"
      return
    end

    print "keymap audit: issues detected; run `just keymap-audit-check` to fail on them"
  end
end
