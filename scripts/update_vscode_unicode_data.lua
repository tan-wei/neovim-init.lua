local M = {}

local SOURCE_URL = "https://raw.githubusercontent.com/microsoft/vscode/main/src/vs/base/common/strings.ts"
local OUTPUT_PATH = "lua/data/unicode_highlight_data.lua"

local function system(args)
  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    error((result.stderr ~= "" and result.stderr or result.stdout):gsub("%s+$", ""))
  end
  return result.stdout
end

local function extract_json_parse_strings(source)
  local strings = {}
  local search_from = 1

  while true do
    local parse_start = source:find("JSON.parse", search_from, true)
    if parse_start == nil then
      break
    end

    local quote_start = source:find("'", parse_start, true)
    if quote_start == nil then
      break
    end

    local index = quote_start + 1
    while index <= #source do
      local char = source:sub(index, index)
      if char == "\\" then
        index = index + 2
      elseif char == "'" then
        table.insert(strings, source:sub(quote_start + 1, index - 1))
        search_from = index + 1
        break
      else
        index = index + 1
      end
    end
  end

  return strings
end

local function decode_js_string_literal(value)
  return (value:gsub("\\'", "'"):gsub('\\"', '"'):gsub("\\\\", "\\"))
end

local function sorted_keys(tbl)
  local keys = vim.tbl_keys(tbl)
  table.sort(keys)
  return keys
end

local function lua_value(value, indent)
  indent = indent or ""
  if vim.islist(value) then
    local lines = { "{" }
    for index = 1, #value, 16 do
      local chunk = {}
      for chunk_index = index, math.min(index + 15, #value) do
        table.insert(chunk, tostring(value[chunk_index]))
      end
      table.insert(lines, indent .. "  " .. table.concat(chunk, ", ") .. ",")
    end
    table.insert(lines, indent .. "}")
    return table.concat(lines, "\n")
  end

  local lines = { "{" }
  for _, key in ipairs(sorted_keys(value)) do
    table.insert(lines, string.format("%s  [%q] = %s,", indent, key, lua_value(value[key], indent .. "  ")))
  end
  table.insert(lines, indent .. "}")
  return table.concat(lines, "\n")
end

local function find_unicode_tables(values)
  local ambiguous = nil
  local invisible = nil
  for _, value in ipairs(values) do
    if type(value) == "table" and not vim.islist(value) then
      if value._default ~= nil then
        ambiguous = value
      elseif value._common ~= nil and value["zh-hans"] ~= nil then
        invisible = value
      end
    end
  end

  if ambiguous == nil or invisible == nil then
    error "Unable to find VS Code Unicode highlighter data tables"
  end

  return ambiguous, invisible
end

function M.update()
  local source = system { "curl", "--fail", "--silent", "--show-error", "--location", SOURCE_URL }
  local values = {}
  for _, literal in ipairs(extract_json_parse_strings(source)) do
    local ok, decoded = pcall(vim.json.decode, decode_js_string_literal(literal))
    if ok then
      table.insert(values, decoded)
    end
  end

  local ambiguous, invisible = find_unicode_tables(values)
  local output = table.concat({
    "-- Generated from microsoft/vscode src/vs/base/common/strings.ts.",
    "-- Source data is produced by https://github.com/hediet/vscode-unicode-data.",
    "-- Regenerate with: just update-vscode-unicode-data",
    "return {",
    "  ambiguous = " .. lua_value(ambiguous, "  ") .. ",",
    "  invisible = " .. lua_value(invisible, "  "),
    "}",
    "",
  }, "\n")

  vim.fn.writefile(vim.split(output, "\n", { plain = true }), OUTPUT_PATH)
  print(string.format("updated %s", OUTPUT_PATH))
end

return M
