local M = {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup {
          background_colour = "#000000",
        }
      end,
    },
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("noice").setup {
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = false,
    },
  }

  require("telescope").load_extension "noice"
end

return M
