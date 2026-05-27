---@type LazyPluginSpec
local M = {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  lazy = false,
}

M.init = function()
  vim.g.rustaceanvim = {
    server = {
      on_attach = function(client, bufnr)
        require("user.lsp.handlers").on_attach(client, bufnr)
      end,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
          },
          checkOnSave = {
            command = "check",
            allTargets = true,
          },
          hover = {
            actions = {
              enable = true,
              gotoTypeDef = true,
              implementations = true,
              references = true,
              run = true,
            },
          },
          runnables = {
            command = "cargo",
          },
          lens = {
            enable = true,
            implementations = {
              enable = true,
            },
            references = {
              enable = true,
            },
            methodReferences = {
              enable = true,
            },
          },
          semanticTokens = {
            enable = true,
          },
        },
      },
    },
    dap = {
      -- TODO
    },
  }

  -- Reload rust-analyzer workspace when mod.rs or Cargo.toml is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("rust_analyzer_reload", { clear = true }),
    pattern = { "mod.rs", "Cargo.toml" },
    desc = "Reload rust-analyzer workspace on mod.rs or Cargo.toml changes",
    callback = function()
      local ok, _ = pcall(function()
        vim.cmd "RustLsp reloadWorkspace"
      end)
      if not ok then
        -- If RustLsp command not available, try direct LSP workspace reload
        vim.lsp.util.buf_request_all(0, "rust-analyzer/reloadWorkspace", nil, function() end)
      end
    end,
  })
end

return M
