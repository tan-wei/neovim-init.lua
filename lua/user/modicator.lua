local status_ok, modicator = pcall(require, "modicator")
if not status_ok then
  return
end

-- TODO: Buggy now, so disable lualine intergration
modicator.setup {
  integration = {
    lualine = {
      enabled = false,
    },
  },
}
