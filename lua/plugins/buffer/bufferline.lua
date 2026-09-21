---@type LazyPluginSpec
local M = {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
}

M.config = function()
  local bufferline = require "bufferline"

  -- Shorten the current working directory when it is too long to fit in the
  -- nvim-tree offset area, keeping the leading "~/" (or "/") and the last
  -- component so the path stays readable.
  local function shorten_path(path, max_len)
    local home = vim.env.HOME
    local str = path
    if home and vim.startswith(str, home) then
      str = "~" .. str:sub(#home + 1)
    end

    if vim.fn.strwidth(str) <= max_len then
      return str
    end

    -- pathshorten(path, 1) keeps the last component and reduces every other
    -- directory to its first character, e.g. /home/u/p/foo/bar -> ~/u/p/f/bar
    str = vim.fn.pathshorten(path, 1)
    if vim.fn.strwidth(str) <= max_len then
      return str
    end

    return vim.fn.truncate(str, math.max(0, max_len - 1)) .. "…"
  end

  bufferline.setup {
    options = {
      mod = "tabs",
      style_preset = bufferline.style_preset.default,
      themable = true,
      numbers = function(opts)
        return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
      end,
      name_formatter = function(buf)
        local is_set, set_true = pcall(vim.api.nvim_buf_get_var, buf.bufnr, "ignore_early_retirement")
        local is_pin = is_set and set_true

        if is_pin then
          return "📌" .. buf.name
        end

        return buf.name
      end,
      close_command = "BdeleteOrClose %d",
      right_mouse_command = "BdeleteOrClose %d",
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
          text = function()
            -- Use the visible width of the nvim-tree window as the available space.
            local ok, api = pcall(require, "nvim-tree.api")
            local winid = ok and api.tree.winid() or nil
            local width = winid and vim.api.nvim_win_get_width(winid) or vim.o.columns
            return shorten_path(vim.fn.getcwd(), width)
          end,
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
