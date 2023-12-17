local M = {
  "rmagatti/goto-preview",
  module = true,
}

M.config = function()
  require("goto-preview").setup {
    width = 120,
    height = 15,
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
    default_mappings = false,
    debug = false,
    opacity = nil,
    resizing_mappings = false,
    post_open_hook = nil,
    post_close_hook = nil,
    references = {
      telescope = require("telescope.themes").get_dropdown {
        hide_preview = false,
      },
    },

    focus_on_open = true,
    dismiss_on_move = false,
    force_close = true,
    bufhidden = "wipe",
    stack_floating_preview_windows = true,
    preview_window_title = {
      enable = true,
      position = "left",
    },
  }
  -- TODO: Add it to which key --
  vim.cmd [[
    nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
    nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
    nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
    nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
    nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
  ]]
end

return M
