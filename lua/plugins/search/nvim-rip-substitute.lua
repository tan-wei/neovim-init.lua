local M = {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("rip-substitute").setup()
end

return M
