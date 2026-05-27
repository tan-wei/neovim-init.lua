---@class UserKeymapEntry
---@field mode string|string[]
---@field lhs string
---@field rhs string|function
---@field desc? string
---@field opts? table<string, any>
---@field plugin? string
---@field family? string
---@field source_file? string
---@field conflict? { builtin?: string, note?: string }
---@field symbol? { family?: string, role?: string, namespace?: string, direction?: string, repeatable?: boolean, repeat_engine?: string|boolean }

---@class UserKeymapGroup
---@field plugin string
---@field family string
---@field maps UserKeymapEntry[]

local M = {}

local META_FIELDS = {
  plugin = true,
  family = true,
  source_file = true,
  conflict = true,
  symbol = true,
}

---@param groups UserKeymapGroup[]
---@param defaults? table<string, any>
---@return UserKeymapEntry[]
local function flatten_groups(groups, defaults)
  local entries = {}

  for _, group in ipairs(groups) do
    for _, entry in ipairs(group.maps) do
      local item = vim.deepcopy(entry)
      item.plugin = item.plugin or group.plugin
      item.family = item.family or group.family
      if defaults then
        for key, value in pairs(defaults) do
          if item[key] == nil then
            item[key] = value
          end
        end
      end
      entries[#entries + 1] = item
    end
  end

  return entries
end

---@param entry UserKeymapEntry
---@return table<string, any>
local function keymap_opts(entry)
  local opts = vim.deepcopy(entry.opts or {})
  if entry.desc and opts.desc == nil then
    opts.desc = entry.desc
  end
  return opts
end

---@param entry UserKeymapEntry
---@return table<string, any>
local function lazy_key_item(entry)
  local item = { entry.lhs, entry.rhs }

  for key, value in pairs(entry) do
    if key ~= "lhs" and key ~= "rhs" and key ~= "opts" and not META_FIELDS[key] then
      item[key] = vim.deepcopy(value)
    end
  end

  if entry.opts then
    for key, value in pairs(entry.opts) do
      item[key] = vim.deepcopy(value)
    end
  end

  return item
end

---@param item table<string, any>
---@return table<string, any>
local function which_key_item(item)
  local clean = vim.deepcopy(item)
  clean.plugin = nil
  clean.family = nil
  clean.conflict = nil
  return clean
end

---@return UserKeymapGroup[]
function M.plain_groups()
  return require "user.keymap.plain"
end

---@return UserKeymapEntry[]
function M.plain_entries()
  return flatten_groups(M.plain_groups(), { source_file = "lua/user/keymap/plain.lua" })
end

function M.apply_plain()
  for _, entry in ipairs(M.plain_entries()) do
    vim.keymap.set(entry.mode, entry.lhs, entry.rhs, keymap_opts(entry))
  end
end

---@param plugin string
---@return UserKeymapEntry[]
function M.lazy_entries(plugin)
  local definitions = require "user.keymap.lazy"
  local groups = definitions[plugin] or {}
  return flatten_groups(groups, { source_file = "lua/user/keymap/lazy.lua" })
end

---@return table<string, UserKeymapGroup[]>
function M.lazy_groups()
  return require "user.keymap.lazy"
end

---@return string[]
function M.lazy_plugins()
  local names = vim.tbl_keys(M.lazy_groups())
  table.sort(names)
  return names
end

---@return table<string, UserKeymapGroup[]>
function M.buffer_groups()
  return require "user.keymap.buffer"
end

---@param plugin? string
---@return UserKeymapEntry[]
function M.buffer_entries(plugin)
  local definitions = M.buffer_groups()
  if plugin then
    return flatten_groups(definitions[plugin] or {}, { source_file = "lua/user/keymap/buffer.lua" })
  end

  local entries = {}
  for _, name in ipairs(M.buffer_plugins()) do
    vim.list_extend(entries, flatten_groups(definitions[name], { source_file = "lua/user/keymap/buffer.lua" }))
  end
  return entries
end

---@return string[]
function M.buffer_plugins()
  local names = vim.tbl_keys(M.buffer_groups())
  table.sort(names)
  return names
end

---@param plugin string
---@param bufnr integer
function M.apply_buffer(plugin, bufnr)
  for _, entry in ipairs(M.buffer_entries(plugin)) do
    local opts = keymap_opts(entry)
    opts.buffer = bufnr
    vim.keymap.set(entry.mode, entry.lhs, entry.rhs, opts)
  end
end

---@param plugin string
---@return table[]
function M.lazy_keys(plugin)
  local items = {}
  for _, entry in ipairs(M.lazy_entries(plugin)) do
    items[#items + 1] = lazy_key_item(entry)
  end
  return items
end

---@return UserKeymapEntry[]
function M.all_entries()
  local entries = M.plain_entries()

  for _, plugin in ipairs(M.lazy_plugins()) do
    vim.list_extend(entries, M.lazy_entries(plugin))
  end

  vim.list_extend(entries, M.buffer_entries())

  return entries
end

---@return table<string, string>
function M.builtin_overrides()
  return require("user.keymap.builtin").all()
end

---@return table[]
function M.which_key_entries()
  return require("user.keymap.which_key").entries()
end

---@return table[]
function M.which_key_items()
  local items = {}
  for _, item in ipairs(M.which_key_entries()) do
    items[#items + 1] = which_key_item(item)
  end
  return items
end

return M
