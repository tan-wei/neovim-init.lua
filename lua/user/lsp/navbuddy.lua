local status_ok, navbuddy = pcall(require, "nvim-navbuddy")
if not status_ok then
  return
end
-- TODO: Configure for navbuddy
navbuddy.setup {}
