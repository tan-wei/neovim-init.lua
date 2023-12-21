local M = {
  "ziontee113/syntax-tree-surfer",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "STSSelectMasterNode",
    "STSSelectCurrentNode",
    "STSSelectNextSiblingNode",
    "STSSelectPrevSiblingNode",
    "STSSelectParentNode",
    "STSSelectChildNode",
    "STSSwapNextVisual",
    "STSSwapPrevVisual",
  },
}

-- TODO: Configure for syntax-tree-surfer
M.opts = {}

return M
