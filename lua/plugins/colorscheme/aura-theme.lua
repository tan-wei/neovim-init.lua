local M = {
  "baliestri/aura-theme",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  -- table.insert(available_colorschemes, "aura-dark") -- buggy
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function(plugin)
  vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
end

return M