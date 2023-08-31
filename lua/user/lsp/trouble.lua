local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  return
end
-- TODO: Configure for trouble
trouble.setup {}
