---@type LazyPluginSpec
local M = {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
}

M.opts = {
  retirementAgeMins = 120,
  ignoredFiletypes = {
    "NvimTree",
    "Outline",
    "qf",
    "help",
    "toggleterm",
    "lazy",
    "mason",
    "alpha",
    "checkhealth",
    "noice",
    "notify",
    "fugitive",
    "neogit",
    "undotree",
    "trouble",
    "TelescopePrompt",
    "TelescopeResults",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
  ignoreFilenamePattern = "",
  ignoreAltFile = true,
  minimumBufferNum = 1,
  ignoreUnsavedChangesBufs = true,
  ignoreSpecialBuftypes = true,
  ignoreVisibleBufs = true,
  ignoreUnloadedBufs = false,
  notificationOnAutoClose = true,
  deleteBufferWhenFileDeleted = false,
  deleteFunction = nil,
}

return M
