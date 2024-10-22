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

  -- TODO: Set g:project according to "Project" if not set
  vim.cmd [[
    function GetGuardWithProjectAndDirectory()
      let l:project   = g:project
      let l:directory = expand('%:p:h:t')
      let l:filename  = expand('%:t')
      let l:guard     = l:project .. '_' .. l:directory .. '_' .. l:filename
      return toupper(substitute(l:guard , "[^a-zA-Z0-9]", "_", "g"))
    endfunction
  ]]

  vim.g.templates_user_variables = {
    { "GUARD_WITH_PROJECT_AND_DIRECTORY", "GetGuardWithProjectAndDirectory" },
  }
  vim.g.templates_use_licensee = 0
end

return M
