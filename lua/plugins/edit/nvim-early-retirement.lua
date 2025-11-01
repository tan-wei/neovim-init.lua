local M = {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
}

M.opts = {
  retirementAgeMins = 120,
  ignoredFiletypes = {},
  ignoreFilenamePattern = "",
  ignoreAltFile = true,
  minimumBufferNum = 1,
  ignoreUnsavedChangesBufs = true,
  ignoreSpecialBuftypes = true,
  ignoreVisibleBufs = true,
  ignoreUnloadedBufs = false,
  notificationOnAutoClose = true,
  deleteBufferWhenFileDeleted = true,
  deleteFunction = nil,
}

return M
