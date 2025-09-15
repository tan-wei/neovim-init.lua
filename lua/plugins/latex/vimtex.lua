local M = {
  "lervag/vimtex",
  lazy = false, -- NOTE: Do not lazy load the plugin
}

-- TODO: Add custom keymaps for other plugins
M.init = function ()
  vim.g.vimtex_view_method = "zathura"
end


return M
