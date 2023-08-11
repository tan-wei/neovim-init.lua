local M = {
  "mg979/vim-visual-multi",
}

M.init = function()
  local VM_maps = {}
  VM_maps["Find Under"] = "<C-d>"
  VM_maps["Find Subword Under"] = "<C-d>"
  VM_maps["Exit"] = "<C-C>"
  VM_maps["Add Cursor Down"] = "<M-j>"
  VM_maps["Add Cursor Up"] = "<M-k>"
  VM_maps["Toggle Mappings"] = "<CR>"

  vim.g.VM_maps = VM_maps
end

return M
