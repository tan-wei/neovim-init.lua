---@type LazyPluginSpec
local M = {
  "emmanueltouzery/decisive.nvim",
  ft = { "csv", "tsv" },
}

M.config = function()
  require("decisive").setup { enable_text_objects = false }

  local registry = require "user.keymap.registry"
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "csv", "tsv" },
    callback = function(args)
      registry.apply_buffer("decisive.nvim", args.buf)
    end,
  })

  if vim.tbl_contains({ "csv", "tsv" }, vim.bo.filetype) then
    registry.apply_buffer("decisive.nvim", vim.api.nvim_get_current_buf())
  end
end

return M
