-- This module implements Unicode character highlighting logic ported from
-- VS Code's built-in Unicode highlighter.
--
-- Reference source:
--   https://github.com/microsoft/vscode/blob/main/src/vs/editor/common/services/unicodeTextModelHighlighter.ts
--   https://github.com/microsoft/vscode/blob/main/src/vs/base/common/strings.ts
--
-- Key differences from VS Code:
--   - Uses mini.hipatterns for rendering instead of editor decorations.
--   - No workspace trust concept; always runs in "trusted" mode.
--   - No hover UI or quick actions to exclude characters.
--   - Comment detection uses Tree-sitter captures instead of tokenization.
--   - Locale detection reads LC_ALL/LC_CTYPE/LANG instead of VS Code's
--     platform.language / Intl.NumberFormat.
--
-- The data tables (lua/data/unicode_highlight_data.lua) are generated from
-- VS Code's strings.ts via scripts/update_vscode_unicode_data.lua.

local data = require "data.unicode_highlight_data"

local M = {}

-- Default options matching VS Code's trusted workspace defaults:
--   ambiguousCharacters=true, invisibleCharacters=true,
--   nonBasicASCII=false, includeComments=false, includeStrings=true
-- (includeStrings is not implemented here; mini.hipatterns applies to all text.)
local default_options = {
  ambiguous_characters = true,
  invisible_characters = true,
  include_comments = false,
  allowed_characters = {},
  allowed_locales = nil,
}

-- Convert a flat [codepoint, primary, codepoint, primary, ...] array
-- from the ambiguous data table into a map { [codepoint] = primary }.
local function array_to_map(array)
  local map = {}
  for index = 1, #array, 2 do
    map[array[index]] = array[index + 1]
  end
  return map
end

-- Intersect two ambiguous maps: only keep entries present in both.
-- This mirrors VS Code's intersectMaps() for locale-specific filtering.
local function intersect_maps(left, right)
  if left == nil then
    return vim.deepcopy(right)
  end

  local result = {}
  for key, value in pairs(left) do
    if right[key] ~= nil then
      result[key] = value
    end
  end
  return result
end

-- Normalize a locale string (e.g. "zh_CN.UTF-8" -> "zh-hans") to match
-- the keys used in the ambiguous data table.
local function normalize_locale(locale)
  if type(locale) ~= "string" or locale == "" then
    return nil
  end

  locale = locale:gsub("[.@].*$", ""):gsub("_", "-"):lower()
  if locale == "zh-cn" or locale == "zh-sg" or locale == "zh-hans" then
    return "zh-hans"
  end
  if locale == "zh-tw" or locale == "zh-hk" or locale == "zh-mo" or locale == "zh-hant" then
    return "zh-hant"
  end
  if locale == "pt-br" then
    return "pt-BR"
  end
  if data.ambiguous[locale] ~= nil then
    return locale
  end

  local primary = locale:match "^([^-]+)"
  if data.ambiguous[primary] ~= nil then
    return primary
  end
end

-- Collect allowed locales from environment variables, mirroring VS Code's
-- resolution of _os locale via Intl.NumberFormat and _vscode via platform.language.
local function default_allowed_locales()
  local locales = {}
  for _, env_name in ipairs { "LC_ALL", "LC_CTYPE", "LANG" } do
    local locale = normalize_locale(vim.env[env_name])
    if locale ~= nil then
      locales[locale] = true
    end
  end
  return vim.tbl_keys(locales)
end

-- Build the final ambiguous character map by merging _common entries with
-- locale-specific entries (intersected across all allowed locales).
-- This mirrors VS Code's AmbiguousCharacters.getInstance(locales).
local function build_ambiguous_map(allowed_locales)
  local locales = {}
  for _, locale in ipairs(allowed_locales or default_allowed_locales()) do
    locale = normalize_locale(locale)
    if locale ~= nil and data.ambiguous[locale] ~= nil then
      table.insert(locales, locale)
    end
  end
  if #locales == 0 then
    locales = { "_default" }
  end

  local language_map = nil
  for _, locale in ipairs(locales) do
    language_map = intersect_maps(language_map, array_to_map(data.ambiguous[locale]))
  end

  local result = array_to_map(data.ambiguous._common)
  for codepoint, primary in pairs(language_map or {}) do
    result[codepoint] = primary
  end
  return result
end

-- Build a set of invisible code points from all locale entries in the data table.
-- VS Code's InvisibleCharacters.codePoints is a flat set; here we flatten
-- the per-locale arrays into a single set.
local function build_invisible_set()
  local result = {}
  for _, codepoints in pairs(data.invisible) do
    for _, codepoint in ipairs(codepoints) do
      result[codepoint] = true
    end
  end
  return result
end

-- Build a set of user-allowed code points from the allowed_characters option.
local function build_allowed_set(allowed_characters)
  local result = {}
  for char, allowed in pairs(allowed_characters or {}) do
    if allowed then
      result[vim.fn.char2nr(char, true)] = true
    end
  end
  return result
end

-- Check if a code point is basic ASCII (tab, newline, CR, or 0x20-0x7e).
-- Mirrors VS Code's isBasicASCII().
local function is_basic_ascii(codepoint)
  return codepoint == 9 or codepoint == 10 or codepoint == 13 or (codepoint >= 0x20 and codepoint <= 0x7e)
end

-- Check if a code point is a word character in ASCII terms (letter, digit, underscore).
-- Used for word-context detection.
local function is_ascii_word(codepoint)
  return codepoint == 0x5f
    or (codepoint >= 0x30 and codepoint <= 0x39)
    or (codepoint >= 0x41 and codepoint <= 0x5a)
    or (codepoint >= 0x61 and codepoint <= 0x7a)
end

-- Iterate over a string and return a list of { char, codepoint, start_col, end_col }.
-- Handles multi-byte UTF-8 sequences correctly.
local function iter_codepoints(text)
  local result = {}
  local index = 1
  while index <= #text do
    local char = text:sub(index, index)
    local byte = char:byte()
    local length = 1
    if byte >= 0xf0 then
      length = 4
    elseif byte >= 0xe0 then
      length = 3
    elseif byte >= 0xc0 then
      length = 2
    end

    char = text:sub(index, index + length - 1)
    table.insert(result, {
      char = char,
      codepoint = vim.fn.char2nr(char, true),
      start_col = index,
      end_col = index + length - 1,
    })
    index = index + length
  end
  return result
end

-- Determine if a code point is part of a "word" for word-context analysis.
-- A code point is word-like if it maps to an ASCII word char via ambiguous table,
-- or is itself an ASCII word char, or is a non-ASCII non-invisible character.
local function is_word_codepoint(codepoint, state)
  local primary = state.ambiguous[codepoint]
  if primary ~= nil then
    return is_ascii_word(primary)
  end
  return is_ascii_word(codepoint) or (codepoint > 0x7f and not state.invisible[codepoint])
end

-- Extract the word surrounding a given column position.
-- Mirrors VS Code's getWordAtText() usage in shouldHighlightNonBasicASCII.
local function get_word_context(line, from_col, state)
  local chars = iter_codepoints(line)
  local char_index = nil
  for index, char in ipairs(chars) do
    if char.start_col <= from_col and from_col <= char.end_col then
      char_index = index
      break
    end
  end
  if char_index == nil or not is_word_codepoint(chars[char_index].codepoint, state) then
    return nil
  end

  local start_index = char_index
  while start_index > 1 and is_word_codepoint(chars[start_index - 1].codepoint, state) do
    start_index = start_index - 1
  end

  local end_index = char_index
  while end_index < #chars and is_word_codepoint(chars[end_index + 1].codepoint, state) do
    end_index = end_index + 1
  end

  local parts = {}
  for index = start_index, end_index do
    table.insert(parts, chars[index].char)
  end
  return table.concat(parts)
end

-- Determine whether to skip highlighting based on word context.
-- This mirrors VS Code's logic: if the word contains no basic ASCII characters
-- AND contains at least one non-confusable non-basic-ASCII character,
-- the character is considered part of a "normal" non-ASCII word and is not highlighted.
-- For example, Greek "λογος" won't highlight the omicron, but "xοx" will.
local function should_skip_word_context(line, from_col, state)
  local word = get_word_context(line, from_col, state)
  if word == nil then
    return false
  end

  local has_basic_ascii = false
  local has_non_confusable_non_basic_ascii = false
  for _, char in ipairs(iter_codepoints(word)) do
    local codepoint = char.codepoint
    has_basic_ascii = has_basic_ascii or is_basic_ascii(codepoint)
    if not is_basic_ascii(codepoint) and state.ambiguous[codepoint] == nil and not state.invisible[codepoint] then
      has_non_confusable_non_basic_ascii = true
    end
  end

  return not has_basic_ascii and has_non_confusable_non_basic_ascii
end

-- Check if a position is inside a comment using Tree-sitter captures.
-- Mirrors VS Code's includeComments option (default: false in trusted workspace).
local function is_comment(bufnr, row, col)
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, bufnr, row, col)
  if not ok then
    return false
  end
  for _, capture in ipairs(captures) do
    if capture.capture:find("comment", 1, true) ~= nil then
      return true
    end
  end
  return false
end

-- Build the internal state (ambiguous map, invisible set, allowed set, pattern list)
-- from the resolved options. This is called once per highlighter() invocation.
local function build_state(options)
  local ambiguous = options.ambiguous_characters and build_ambiguous_map(options.allowed_locales) or {}
  local invisible = options.invisible_characters and build_invisible_set() or {}
  local allowed = build_allowed_set(options.allowed_characters)
  local patterns = {}
  local seen = {}

  for codepoint in pairs(invisible) do
    if not allowed[codepoint] and codepoint ~= 0x20 and codepoint ~= 0x0a and codepoint ~= 0x09 then
      seen[codepoint] = true
    end
  end
  for codepoint in pairs(ambiguous) do
    if not allowed[codepoint] then
      seen[codepoint] = true
    end
  end

  local sorted = vim.tbl_keys(seen)
  table.sort(sorted)
  for _, codepoint in ipairs(sorted) do
    table.insert(patterns, vim.fn.nr2char(codepoint, true))
  end

  return {
    ambiguous = ambiguous,
    invisible = invisible,
    allowed = allowed,
    patterns = patterns,
  }
end

-- Public API: returns a mini.hipatterns highlighter table.
-- The group callback applies the same decision logic as VS Code's
-- CodePointHighlighter.shouldHighlightNonBasicASCII():
--   1. Skip if code point is in allowed set.
--   2. Skip if inside a comment (when include_comments=false).
--   3. Skip word-context heuristic (pure non-ASCII words).
--   4. Highlight if invisible or ambiguous.
function M.highlighter(options)
  options = vim.tbl_deep_extend("force", default_options, options or {})
  local state = build_state(options)

  return {
    pattern = state.patterns,
    group = function(bufnr, match, match_data)
      local codepoint = vim.fn.char2nr(match, true)
      if state.allowed[codepoint] then
        return nil
      end

      if not options.include_comments and is_comment(bufnr, match_data.line - 1, match_data.from_col - 1) then
        return nil
      end

      local line = vim.api.nvim_buf_get_lines(bufnr, match_data.line - 1, match_data.line, false)[1] or ""
      if should_skip_word_context(line, match_data.from_col, state) then
        return nil
      end

      if options.invisible_characters and state.invisible[codepoint] then
        return "UnicodeHighlight"
      end
      if options.ambiguous_characters and state.ambiguous[codepoint] then
        return "UnicodeHighlight"
      end
    end,
  }
end

return M
