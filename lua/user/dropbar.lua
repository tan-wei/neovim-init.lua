local status_ok, dropbar = pcall(require, "dropbar")
if not status_ok then
  return
end

-- TODO: Configure for dropbar
dropbar.setup()
