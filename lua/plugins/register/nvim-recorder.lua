local M = {
  "chrisgrieser/nvim-recorder",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  lazy = false,
}

M.opts = {
  mapping = {
    slots = { "a", "b", "c", "d", "e", "f" },
    dynamicSlots = "rotate",
    startStopRecording = "q",
    playMacro = "Q",
    switchSlot = "<C-q>",
    editMacro = "cq",
    yankMacro = "yq",
    deleteAllMacros = "dq",
    addBreakPoint = "##",
    clear = true,
  },
}

return M
