local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
  return
end

neogen.setup {
  snippet_engine = "luasnip",
  languages = {
    ["cpp.doxygen"] = require "neogen.configurations.cpp",
    ["c.doxygen"] = require "neogen.configurations.c",
  },
}
