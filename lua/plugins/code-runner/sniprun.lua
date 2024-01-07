local M = {
  "michaelb/sniprun",
  build = "sh ./install.sh",
  enabled = require("util.package").enabled_unix_only(),
  cmd = { "SnipRun", "SnipInfo" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
