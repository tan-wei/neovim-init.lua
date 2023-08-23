local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local snippets = require "user.snippets"

for lang, snippet in pairs(snippets) do
  luasnip.add_snippets(lang, snippet)
end
