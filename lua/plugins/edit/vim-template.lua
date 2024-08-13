local M = {
  "aperezdc/vim-template",
  cmd = { "Template", "TemplateHere" },
}

M.init = function()
  vim.g.templates_no_autocmd = 0
  vim.g.templates_directory = { vim.fn.stdpath "config" .. "/templates/vim-template/" }
  vim.g.templates_name_prefix = ".vim-template:"
  vim.g.templates_global_name_prefix = "=template="
  vim.g.templates_no_builtin_templates = 0
  vim.g.templates_user_variables = {}
  vim.g.templates_use_licensee = 0
end

return M
