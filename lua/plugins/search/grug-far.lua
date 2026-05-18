local M = {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
}

M.opts = {
  transient = true,
  windowCreationCommand = "botright vsplit",
}

return M
