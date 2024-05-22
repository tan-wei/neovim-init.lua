local M = {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("actions-preview").setup {
    highlight_command = {
      require("actions-preview.highlight").delta("delta --no-gitconfig --side-by-side --line-numbers --paging=always"),
      require("actions-preview.highlight").diff_so_fancy(),
      require("actions-preview.highlight").diff_highlight(),
    },
    backend = { "telescope", "nui" },
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.8,
        height = 0.9,
        prompt_position = "top",
        preview_cutoff = 20,
        preview_height = function(_, _, max_lines)
          return max_lines - 15
        end,
      },
    },
  }
end

return M
