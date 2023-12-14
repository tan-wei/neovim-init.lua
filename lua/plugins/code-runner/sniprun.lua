local M = {
  "michaelb/sniprun",
  build = "sh ./install.sh",
  enabled = function()
    if vim.uv.os_uname().sysname ~= "Windows_NT" then
      return true
    else
      return false
    end
  end,
  cmd = { "SnipRun", "SnipInfo" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
