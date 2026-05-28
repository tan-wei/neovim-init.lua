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

local FAIL_ON_MISSING = vim.env.KEYMAP_DOCS_FAIL_ON_MISSING == "1"

local function trim(value)
  return (value or ""):match "^%s*(.-)%s*$"
end

local function strip_ticks(value)
  return trim((value or ""):gsub("`", ""))
end

local function split_csv(value)
  local items = {}
  for part in (value or ""):gmatch "[^,]+" do
    local item = strip_ticks(part)
    if item ~= "" then
      items[#items + 1] = item
    end
  end
  return items
end

local function dedupe(items)
  local seen = {}
  local result = {}

  for _, item in ipairs(items) do
    if item ~= "" and not seen[item] then
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

    local normalized = strip_ticks(value):lower()
    if normalized == "" then
      return
    end

    if normalized == "all" then
      vim.list_extend(modes, { "n", "v", "x", "s", "o", "i", "c", "t" })
      return
    end

    if #normalized == 1 then
      modes[#modes + 1] = normalized
      return
    end

    for _, token in ipairs(split_csv(normalized)) do
      if #token == 1 then
        modes[#modes + 1] = token
      end
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

local function normalize_lhs(lhs)
  local cleaned = strip_ticks(lhs):gsub("\\|", "|")
  if cleaned == "" then
    return ""
  end
  return vim.keycode(cleaned)
end

local function key_id(mode, lhs)
  return mode .. "\t" .. normalize_lhs(lhs)
end

local function wildcard_key_id(lhs)
  return "*\t" .. normalize_lhs(lhs)
end

local function printable_lhs(lhs)
  return strip_ticks(lhs):gsub("\\|", "|")
end

local function split_markdown_row(line)
  if type(line) ~= "string" or not line:match "^|" then
    return nil
  end

  local placeholder = string.char(31)
  local protected = line:gsub("\\|", placeholder)

  if protected:sub(1, 1) == "|" then
    protected = protected:sub(2)
  end
  if protected:sub(-1) == "|" then
    protected = protected:sub(1, -2)
  end

  local cells = {}
  for cell in (protected .. "|"):gmatch "(.-)|" do
    cells[#cells + 1] = trim(cell:gsub(placeholder, "|"))
  end

  return cells
end

local function is_table_separator(line)
  return type(line) == "string" and line:match "^|[%s:|%-]+|%s*$" ~= nil
end

local function documented_ids()
  local lines = vim.fn.readfile(ROOT .. "/README.md")
  local documented = {}
  local index = 1

  local function record(mode, lhs)
    local normalized_lhs = normalize_lhs(lhs)
    if normalized_lhs == "" then
      return
    end
    documented[key_id(mode, lhs)] = true
  end

  while index <= #lines do
    local line = lines[index]

    local header = split_markdown_row(line)
    local separator = lines[index + 1]
    if not (header and is_table_separator(separator)) then
      index = index + 1
      goto continue
    end

    local header_key = table.concat(
      vim.tbl_map(function(cell)
        return strip_ticks(cell):lower()
      end, header),
      "|"
    )
    index = index + 2

    while index <= #lines do
      local row_line = lines[index]
      local row = split_markdown_row(row_line)
      if not row or is_table_separator(row_line) then
        break
      end

      if header_key == "mode|key|current meaning|overrides builtin|replaced meaning / notes" then
        for _, mode in ipairs(normalize_modes(row[1])) do
          for _, lhs in ipairs(split_csv(row[2])) do
            record(mode, lhs)
          end
        end
      elseif header_key == "prefix|leaf keys|current meaning|overrides builtin|notes" then
        for _, lhs in ipairs(split_csv(row[2])) do
          documented[wildcard_key_id("<leader>" .. lhs)] = true
        end
      end

      index = index + 1
    end

    ::continue::
  end

  return documented
end

local function actual_entries()
  local registry = require "user.keymap.registry"
  local items = {}

  local function push(entry, source)
    if entry.group ~= nil then
      return
    end

    local lhs = entry.lhs or entry[1]
    local rhs = entry.rhs or entry[2]
    local modes = normalize_modes(entry.mode or "n")
    if lhs == nil or rhs == nil then
      return
    end

    for _, mode in ipairs(modes) do
      items[#items + 1] = {
        id = key_id(mode, lhs),
        mode = mode,
        lhs = printable_lhs(lhs),
        source = source,
        plugin = entry.plugin,
      }
    end
  end

  for _, entry in ipairs(require("user.keymap.registry").all_entries()) do
    push(entry, entry.source_file or "<unknown>")
  end

  for _, entry in ipairs(registry.which_key_entries()) do
    push(entry, "lua/user/keymap/which_key.lua")
  end

  table.sort(items, function(left, right)
    if left.mode == right.mode then
      return left.lhs < right.lhs
    end
    return left.mode < right.mode
  end)

  return items
end

local documented = documented_ids()
local actual = actual_entries()
local missing = {}
local seen = {}

for _, entry in ipairs(actual) do
  if not documented[entry.id] and not documented[wildcard_key_id(entry.lhs)] and not seen[entry.id] then
    seen[entry.id] = true
    missing[#missing + 1] = entry
  end
end

print(string.format("Configured central keymaps checked: %d", #actual))
if #missing == 0 then
  print "README keymap tables cover all central registry and which-key mappings."
  return
end

print(string.format("Undocumented configured keymaps: %d", #missing))
for _, entry in ipairs(missing) do
  local plugin = entry.plugin and (" [" .. entry.plugin .. "]") or ""
  print(string.format("- %s %s (%s)%s", entry.mode, entry.lhs, entry.source, plugin))
end

if FAIL_ON_MISSING then
  vim.api.nvim_echo({ { "README keymap tables are missing configured mappings", "ErrorMsg" } }, true, {})
  vim.cmd "cquit 1"
end
