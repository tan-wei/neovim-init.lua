local status_ok, modicator = pcall(require, "modicator")
if not status_ok then
  return
end

modicator.setup()
