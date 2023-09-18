local status_ok, lsp_lens = pcall(require, "lsp-lens")
if not status_ok then
  return
end

lsp_lens.setup {
  enable = true,
  include_declaration = false, -- Reference include declaration
  sections = { -- Enable / Disable specific request
    definition = false,
    references = true,
    implements = true,
  },
  ignore_filetype = {
    "prisma",
  },
}

vim.api.nvim_set_hl(0, "LspLens", { link = "LspCodeLens" })
