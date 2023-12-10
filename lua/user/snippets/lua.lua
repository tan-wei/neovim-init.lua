local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

return {
  --- PLUGIN ---
  s(
    {
      trig = "plu",
      name = "Plugin",
    },
    fmt(
      [[
local M = {{
  "{}",
}}



return M
  ]],
      i(1, "plugin")
    )
  ),

  --- SNIPPET ---
  s(
    {
      trig = "sni",
      name = "Snippet",
    },
    fmt(
      [[
local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

return {{
  {}
}}
  ]],
      i(1, "snippet")
    )
  ),
}
