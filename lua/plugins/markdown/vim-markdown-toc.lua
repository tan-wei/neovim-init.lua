---@type LazyPluginSpec
local M = {
  "mzlogin/vim-markdown-toc",
  cmd = {
    "GenTocGFM",
    "GenTocGitLab",
    "GenTocRedcarpet",
    "GenTocMarked",
    "GenTocModeline",
    "UpdateToc",
    "RemoveToc",
    "TocGoto",
  },
}

M.init = function()
  local project_config = require "util.project_config"

  vim.g.vmt_auto_update_on_save = project_config.get "vmt_auto_update_on_save"
  vim.g.vmt_dont_insert_fence = project_config.get "vmt_dont_insert_fence"
  vim.g.vmt_cycle_list_item_markers = project_config.get "vmt_cycle_list_item_markers"
  vim.g.vmt_list_item_chars = project_config.get "vmt_list_item_chars"
end

return M
