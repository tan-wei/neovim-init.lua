local status_ok, glance = pcall(require, "glance")
if not status_ok then
  return
end

glance.setup()
