local M = {
  "google/executor.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "ExecutorRun",
    "ExecutorSetCommand",
    "ExecutorShowDetail",
    "ExecutorHideDetail",
    "ExecutorToggleDetail",
    "ExecutorSwapToSplit",
    "ExecutorSwapToPopup",
    "ExecutorShowPresets",
    "ExecutorShowHistory",
    "ExecutorReset",
    "ExecutorOneOff",
  },
}

M.opts = {
  use_split = false,
  output_filter = function(command, lines)
    return lines
  end,
}

return M
