local M = {
  "Saecki/crates.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufRead Cargo.toml" },
}

M.config = function()
  local is_blink = vim.g.completion_engine == "blink"

  require("crates").setup {
    -- Enable in-process language server for completions (works with any LSP-aware completion engine)
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
    completion = {
      crates = {
        enabled = true,
        max_results = 8,
        min_chars = 3,
      },
      -- Only enable the nvim-cmp specific source when using nvim-cmp
      cmp = { enabled = not is_blink },
    },
  }

  if not is_blink then
    local cmp = require "cmp"
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        cmp.setup.buffer { sources = { { name = "crates" } } }
      end,
    })
  end
end

return M
