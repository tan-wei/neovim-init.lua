---@type LazyPluginSpec
local M = {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
}

M.config = function()
  require("nvim-lightbulb").setup {
    priority = 100,
    sign = {
      enabled = true,
      text = "💡",
      lens_text = "🔎",
      hl = "LightBulbSign",
    },
    status_text = {
      enabled = true,
      text = "💡",
      lens_text = "🔎",
      text_unavailable = "",
    },
    number = {
      enabled = true,
      hl = "LightBulbNumber",
    },
    autocmd = {
      enabled = true,
      updatetime = 200,
      events = { "CursorHold", "CursorHoldI" },
      pattern = { "*" },
    },
    ignore = {
      clients = {},
      ft = {},
      actions_without_kind = false,
    },
  }
end

return M
