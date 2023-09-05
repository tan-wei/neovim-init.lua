local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
  return
end

-- TODO: Configure for neogit
neogit.setup()
