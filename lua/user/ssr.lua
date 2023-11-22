local status_ok, ssr = pcall(require, "ssr")
if not status_ok then
  return
end

ssr.setup()
