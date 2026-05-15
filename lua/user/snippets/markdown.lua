local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local d = luasnip.dynamic_node

local function separator_line(column_count)
  local segments = {}

  for _ = 1, column_count do
    table.insert(segments, " --- ")
  end

  return "|" .. table.concat(segments, "|") .. "|"
end

local function markdown_table(_, snip)
  local row_count = tonumber(snip.captures[1]) or 1
  local column_count = tonumber(snip.captures[2]) or 1
  local nodes = {}
  local insert_index = 0

  for column = 1, column_count do
    insert_index = insert_index + 1
    table.insert(nodes, t("| "))
    table.insert(nodes, i(insert_index, "Column" .. column))
    table.insert(nodes, t(" "))
  end

  table.insert(nodes, t({ "|", separator_line(column_count), "" }))

  for row = 1, row_count do
    for _ = 1, column_count do
      insert_index = insert_index + 1
      table.insert(nodes, t("| "))
      table.insert(nodes, i(insert_index))
      table.insert(nodes, t(" "))
    end

    if row == row_count then
      table.insert(nodes, t("|"))
    else
      table.insert(nodes, t({ "|", "" }))
    end
  end

  return sn(nil, nodes)
end

return {
  s(
    {
      trig = "table(%d+)x(%d+)",
      regTrig = true,
      name = "Markdown Table",
      dscr = "Dynamic markdown table from rows x cols",
    },
    d(1, markdown_table, {})
  ),
}