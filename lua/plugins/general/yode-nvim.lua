local M = {
  "hoschi/yode-nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "YodeCreateSeditorFloating",
    "YodeCreateSeditorReplace",
    "YodeBufferDelete",
    "YodeGoToAlternateBuffer",
    "YodeCloneCurrentIntoFloat",
    "YodeFloatToMainWindow",
    "YodeFormatWrite",
    "YodeRunInFile",
  },
}

M.config = function()
  require("yode-nvim").setup()
end

return M
