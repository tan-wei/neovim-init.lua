local M = {
  "cbochs/grapple.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "Grapple",
    "GrappleTag",
    "GrappleUntag",
    "GrappleToggle",
    "GrappleCycle",
    "GrappleSelect",
    "GrappleReset",
    "GrapplePopup",
  },
}

M.config = true

return M
