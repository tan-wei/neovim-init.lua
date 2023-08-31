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
}

M.init = function() end

return M
