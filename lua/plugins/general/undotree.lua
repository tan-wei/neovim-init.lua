local M = {
  "mbbill/undotree",
}

M.init = function()
  vim.g.undotree_SetFocusWhenToggle = 1

  if vim.fn.has "persistent_undo" == 1 then
    local undotree_dir = vim.fn.stdpath "data" .. "/undotree"
    local target_path = vim.fn.expand(undotree_dir)
    if vim.fn.isdirectory(target_path) == 0 or vim.fn.isdirectory(target_path) == false then
      vim.fn.mkdir(target_path, "p", 0700)
    end
    vim.o.undodir = target_path
    vim.o.undofile = true
  end
end

return M
