local M = {
  "chrisgrieser/nvim-recorder",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  lazy = false,
}

M.opts = {
  mapping = {
    startStopRecording = "q",
    playMacro = "Q",
    switchSlot = "<C-q>",
    editMacro = "cq",
    yankMacro = "yq",
    deleteAllMacros = "dq",
    addBreakPoint = "##",
  },
}

return M
