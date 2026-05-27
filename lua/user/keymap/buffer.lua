local builtin = require "user.keymap.builtin"

local silent_opts = { silent = true }

---@type table<string, UserKeymapGroup[]>
return {
  lsp = {
    {
      plugin = "lsp",
      family = "buffer",
      maps = {
        {
          mode = "n",
          lhs = "gD",
          rhs = function()
            vim.lsp.buf.declaration()
          end,
          desc = "LSP: Declaration",
          opts = silent_opts,
          conflict = { builtin = builtin.get("n", "gD") },
        },
        {
          mode = "n",
          lhs = "gd",
          rhs = function()
            vim.lsp.buf.definition()
          end,
          desc = "LSP: Definition",
          opts = silent_opts,
          conflict = { builtin = builtin.get("n", "gd") },
        },
        {
          mode = "n",
          lhs = "K",
          rhs = function()
            vim.lsp.buf.hover { border = "rounded" }
          end,
          desc = "LSP: Hover",
          opts = silent_opts,
          conflict = {
            builtin = builtin.get("n", "K"),
            note = "Shadows the global nvim-ufo K in LSP-attached buffers",
          },
        },
        {
          mode = "n",
          lhs = "gI",
          rhs = function()
            vim.lsp.buf.implementation()
          end,
          desc = "LSP: Implementation",
          opts = silent_opts,
          conflict = { builtin = builtin.get("n", "gI") },
        },
        {
          mode = "n",
          lhs = "gr",
          rhs = function()
            vim.lsp.buf.references()
          end,
          desc = "LSP: References",
          opts = silent_opts,
          conflict = { builtin = builtin.get("n", "gr") },
        },
        {
          mode = "n",
          lhs = "gl",
          rhs = function()
            vim.diagnostic.open_float()
          end,
          desc = "LSP: Diagnostics",
          opts = silent_opts,
          conflict = {
            note = "Reviewed normal-mode g-family slot before reusing it for diagnostics",
          },
        },
      },
    },
  },
}
