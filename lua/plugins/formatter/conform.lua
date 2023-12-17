local M = {
  "stevearc/conform.nvim",
  event = "VeryLazy",
}

M.init = function()
  vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
      print "Disable format on save for this buffer"
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  })
  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false

    print "Re-enable format on save for this buffer"
  end, {
    desc = "Re-enable autoformat-on-save",
  })
end

M.config = function()
  require("conform").setup {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { { "prettierd", "prettier" } },
      rust = { "rustfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    -- format_after_save = {
    -- lsp_fallback = true,
    -- },
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
  }
end

return M
