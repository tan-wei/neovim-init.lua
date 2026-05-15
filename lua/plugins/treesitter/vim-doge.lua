local M = {
  "kkoomen/vim-doge",
  build = ":call doge#install({ 'headless': 1 })",
  ft = { "c", "cpp" },
  cmd = {
    "DogeGenerate",
  },
}

M.init = function()
  vim.g.doge_enable_mappings = 0
  vim.g.doge_buffer_mappings = 1
  vim.g.doge_mapping_comment_jump_forward = "]d"
  vim.g.doge_mapping_comment_jump_backward = "[d"
  vim.g.doge_comment_jump_modes = { "n", "s" }
  vim.g.doge_doc_standard_c = "doxygen_javadoc"
  vim.g.doge_doc_standard_cpp = "doxygen_javadoc"
end

return M