local all = require "user.snippets.all"
local cpp = require "user.snippets.cpp"
local lua = require "user.snippets.lua"
local markdown = require "user.snippets.markdown"
local tex = require "user.snippets.tex"

---@type { all: any[], cpp: any[], lua: any[], markdown: any[], tex: any[] }
local M = {
  all = all,
  cpp = cpp,
  lua = lua,
  markdown = markdown,
  tex = tex,
}

return M
