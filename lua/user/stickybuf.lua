local status_ok, stickybuf = pcall(require, "skickybuf")
if not status_ok then
  return
end

stickybuf.setup()
