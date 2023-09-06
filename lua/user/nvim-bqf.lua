local status_ok, bqf = pcall(require, "bqf")
if not status_ok then
  return
end

-- TODO: Configure for nvim-bqf
bqf.setup()
