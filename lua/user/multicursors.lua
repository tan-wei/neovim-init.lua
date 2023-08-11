local status_ok, multicursors = pcall(require, "multicursors")
if not status_ok then
  return
end

multicursors.setup {}
