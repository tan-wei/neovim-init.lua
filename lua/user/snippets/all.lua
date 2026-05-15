local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function split_commentstring(commentstring)
  if commentstring == nil or commentstring == "" then
    return { "//", "" }
  end

  local left, right = commentstring:match("^(.*)%%s(.*)$")
  if left == nil then
    return { vim.trim(commentstring), "" }
  end

  return {
    vim.trim(left),
    vim.trim(right),
  }
end

local function get_comment_parts(ctype)
  local ok_ft, comment_ft = pcall(require, "Comment.ft")
  local ok_utils, comment_utils = pcall(require, "Comment.utils")

  if ok_ft and ok_utils then
    local ok_calculate, commentstring = pcall(comment_ft.calculate, {
      ctype = ctype,
      range = comment_utils.get_region(),
    })

    if ok_calculate and type(commentstring) == "string" and commentstring ~= "" then
      local ok_unwrap, left, right = pcall(comment_utils.unwrap_cstr, commentstring)
      if ok_unwrap then
        return {
          vim.trim(left or ""),
          vim.trim(right or ""),
        }
      end
    end
  end

  return split_commentstring(vim.bo.commentstring)
end

local function comment_left(ctype)
  return function()
    return get_comment_parts(ctype)[1]
  end
end

local function comment_right(ctype)
  return function()
    local right = get_comment_parts(ctype)[2]
    if right == nil or right == "" then
      return ""
    end

    return " " .. right
  end
end

local function mark_choices()
  local username = vim.env.USER or "user"

  return {
    t(""),
    sn(nil, fmt(" <{}>", { i(1, username) })),
    sn(nil, fmt(" <{}>", { i(1, os.date "%F") })),
    sn(nil, fmt(" <{}, {}>", { i(1, os.date "%F"), i(2, username) })),
  }
end

local function alias_choices(aliases)
  local choices = {}

  for _, alias in ipairs(aliases) do
    table.insert(choices, sn(nil, { i(1, alias) }))
  end

  return choices
end

local function todo_snippet(context, aliases, opts)
  opts = opts or {}
  aliases = type(aliases) == "string" and { aliases } or aliases

  return s(
    context,
    fmt("{} {}: {}{}{}", {
      f(comment_left(opts.ctype or 1)),
      c(2, alias_choices(aliases)),
      i(1, "message"),
      c(3, mark_choices()),
      f(comment_right(opts.ctype or 1)),
    })
  )
end

local function box_nodes(opts)
  local padding_length = opts.padding_length or 6

  local function pick_edges()
    local left, right = unpack(get_comment_parts(1))
    if right == nil or right == "" then
      right = left
    end

    return left, right
  end

  return {
    f(function(args)
      local left, right = pick_edges()
      local fill = string.sub(left, #left, #left)
      if fill == "" then
        fill = string.sub(right, 1, 1)
      end
      if fill == "" then
        fill = "-"
      end

      return left .. string.rep(fill, #args[1][1] + 2 * padding_length) .. right
    end, { 1 }),
    t({ "", "" }),
    f(function()
      local left = pick_edges()
      return left .. string.rep(" ", padding_length)
    end),
    i(1, "comment"),
    f(function()
      local _, right = pick_edges()
      return string.rep(" ", padding_length) .. right
    end),
    t({ "", "" }),
    f(function(args)
      local left, right = pick_edges()
      local fill = string.sub(right, 1, 1)
      if fill == "" then
        fill = string.sub(left, #left, #left)
      end
      if fill == "" then
        fill = "-"
      end

      return left .. string.rep(fill, #args[1][1] + 2 * padding_length) .. right
    end, { 1 }),
  }
end

return {
  todo_snippet({ trig = "todo", name = "TODO comment", dscr = "Comment-aware TODO" }, "TODO"),
  todo_snippet({ trig = "fix", name = "FIX comment", dscr = "Comment-aware FIX/BUG" }, { "FIX", "BUG", "ISSUE", "FIXIT" }),
  todo_snippet({ trig = "warn", name = "WARN comment", dscr = "Comment-aware WARN" }, { "WARN", "WARNING", "XXX" }),
  todo_snippet({ trig = "note", name = "NOTE comment", dscr = "Comment-aware NOTE" }, { "NOTE", "INFO" }),
  todo_snippet({ trig = "todob", name = "Block TODO comment", dscr = "Block-comment TODO" }, "TODO", { ctype = 2 }),
  s({ trig = "box", name = "Comment Box", dscr = "Comment-aware box comment" }, box_nodes { padding_length = 6 }),
  s({ trig = "bbox", name = "Wide Comment Box", dscr = "Comment-aware wide box comment" }, box_nodes { padding_length = 12 }),
}