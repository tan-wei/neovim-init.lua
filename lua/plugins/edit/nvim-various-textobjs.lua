local M = {
  "chrisgrieser/nvim-various-textobjs",
  enabled = false,
  lazy = true,
}

-- TODO: This plugin should write more configurations
M.config = function()
  -- default config
  require("various-textobjs").setup {
    lookForwardSmall = 5,
    lookForwardBig = 15,
    useDefaultKeymaps = false,
    disabledKeymaps = {},
  }
end

return M
