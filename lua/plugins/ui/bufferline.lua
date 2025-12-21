local M = {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "moll/vim-bbye",
  },
  event = "VeryLazy",
}

M.config = function()
  local bufferline = require "bufferline"
  bufferline.setup {
    options = {
      mod = "tabs",
      style_preset = bufferline.style_preset.default,
      themable = true,
      numbers = function(opts)
        return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
      end,
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      indicator = { style = "icon", icon = "▎" },
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 30,
      tab_size = 21,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        if context.buffer:current() then
          -- Does not show indicator when it is the current buffer
          return ""
        end
        local icon = level:match "error" and " " or " "
        return " " .. icon .. count
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          separator = true,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      separator_style = "thick",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      auto_toggle_bufferline = true,
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
      sort_by = "insert_after_current",
    },
  }
end

return M
