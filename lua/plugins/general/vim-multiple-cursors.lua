local M = {
  "mg979/vim-visual-multi",
  branch = "master",
}

M.init = function()
  vim.g.VM_default_mappings = 0
  vim.g.VM_mouse_mappings = 1
  vim.g.VM_maps = {
    ["Find Under"] = "<C-d>",
    ["Find Subword Under"] = "",
    ["Select Cursor Down"] = "<M-C-Down>",
    ["Select Cursor Up"] = "<M-C-Up>",
  }
end

return M
