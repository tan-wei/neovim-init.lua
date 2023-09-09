local status_ok, iswap = pcall(require, "iswap")
if not status_ok then
  return
end

-- TODO: Configure for iswap.nvim
iswap.setup()
