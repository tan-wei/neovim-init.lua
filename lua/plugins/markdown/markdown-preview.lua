local M = {
  "iamcco/markdown-preview.nvim",
  build = "cd app && yarn install",
}

M.init = function()
  vim.g.mkdp_path_to_chrome = "chrome"
  vim.g.mkdp_markdown_css = ""
end

return M
