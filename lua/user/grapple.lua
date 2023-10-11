local status_ok, grapple = pcall(require, "grapple")
if not status_ok then
  return
end

-- Default configure is OK
grapple.setup()
