local status_ok, sniprun = pcall(require, "sniprun")
if not status_ok then
  return
end

-- TODO: Configure for sniprun
sniprun.setup()
