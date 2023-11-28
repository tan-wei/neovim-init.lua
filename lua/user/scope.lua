local status_ok, scope = pcall(require, "scope")
if not status_ok then
  return
end

scope.setup()

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "scope"
