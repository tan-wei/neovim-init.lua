local status_ok, attempt = pcall(require, "attemp")
if not status_ok then
  return
end

-- TODO: Configure for attempt.nvim
attempt.setup()

local tele_status_ok, telescope = pcall(require, "telescope")
if tele_status_ok then
  telescope.load_extension "attempt"
end
