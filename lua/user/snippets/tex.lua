local luasnip = require "luasnip"
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local tex = {}

tex.in_mathzone = function()
  local ok, result = pcall(vim.fn["vimtex#syntax#in_mathzone"])
  return ok and result == 1
end

tex.in_text = function()
  return not tex.in_mathzone()
end

tex.in_beamer = function()
  if type(vim.b.vimtex) == "table" and vim.b.vimtex.documentclass == "beamer" then
    return true
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match "\\documentclass%b{}" and line:match "beamer" then
      return true
    end
  end

  return false
end

return {
  s({
    trig = "mk",
    name = "Inline Math",
    dscr = "Inline math, only in text",
  }, fmt("${}$", { i(1) }), { condition = tex.in_text }),

  s(
    {
      trig = "dm",
      name = "Display Math",
      dscr = "Display math, only in text",
    },
    fmt(
      [[
\\[
  {}
\\]
      ]],
      { i(1) }
    ),
    { condition = tex.in_text }
  ),

  s({
    trig = "ff",
    name = "Fraction",
    dscr = "Fraction, only in math mode",
  }, fmt("\\frac{{{}}}{{{}}}", { i(1), i(2) }), { condition = tex.in_mathzone }),

  s({
    trig = "txt",
    name = "Text In Math",
    dscr = "Text wrapper, only in math mode",
  }, fmt("\\text{{{}}}", { i(1) }), { condition = tex.in_mathzone }),

  s(
    {
      trig = "bfr",
      name = "Beamer Frame",
      dscr = "Frame snippet, only in beamer documents",
    },
    fmt(
      [[
\\begin{{frame}}
  \\frametitle{{{}}}
  {}
\\end{{frame}}
      ]],
      {
        i(1, "frame title"),
        i(0),
      }
    ),
    { condition = tex.in_beamer }
  ),
}
