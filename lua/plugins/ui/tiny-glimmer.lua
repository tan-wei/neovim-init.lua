---@type LazyPluginSpec
local M = {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
}

M.config = function()
  -- Upstream reads buffer-local mappings with maparg, but wraps them globally.
  -- A scratch buffer ensures it captures only global mappings (e.g. Yanky's p/P).
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(buf, function()
    require("tiny-glimmer").setup {
      disable_warnings = true,
      default_animation = "pulse",
    }
  end)
  vim.api.nvim_buf_delete(buf, { force = true })
end

return M
