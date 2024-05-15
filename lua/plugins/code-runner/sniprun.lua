local M = {
  "michaelb/sniprun",
  build = "sh ./install.sh",
  enabled = require("util.package").enabled_unix_only(),
  cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose" },
}

-- NOTE: Default configure is OK for now
M.config = true

return M
