local M = {
  "johmsalas/text-case.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "TextCaseOpenTelescope", "TextCaseOpenTelescopeQuickChange", "TextCaseOpenTelescopeLSPChange" },
}

-- TODO: Keymaps should be added in which-key
M.config = function()
  require("textcase").setup {
    prefix = "ga",
  }
  require("telescope").load_extension "textcase"
end

return M
