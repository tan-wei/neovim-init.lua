local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then
  return
end

scrollbar.setup()

local gitsigns_status_ok, _ = pcall(require, "gitsigns")
if gitsigns_status_ok then
  require("scrollbar.handlers.gitsigns").setup()
end

local hlslens_status_ok, _ = pcall(require, "hlslens")
if hlslens_status_ok then
  require("scrollbar.handlers.search").setup()
end
