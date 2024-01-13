local M = {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "luukvbaal/statuscol.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  local ftMap = {
    vim = "indent",
    python = { "indent" },
    git = "",
    lua = { "lsp", "treesitter" },
    rust = { "lsp", "treesitter" },
    c = { "lsp", "treesitter" },
    cpp = { "lsp", "treesitter" },
  }

  local ufo = require "ufo"

  ufo.setup {
    open_fold_hl_timeout = 150,
    close_fold_kinds = { "imports", "comment" },
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        winhighlight = "Normal:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
    provider_selector = function(bufnr, filetype, buftype)
      if vim.bo[bufnr].buftype == "nofile" then
        return ""
      end
      return ftMap[filetype] or { "treesitter", "indent" }
    end,
  }

  vim.keymap.set("n", "zR", ufo.openAllFolds)
  vim.keymap.set("n", "zM", ufo.closeAllFolds)
  vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
  vim.keymap.set("n", "zm", ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  vim.keymap.set("n", "K", function()
    local winid = ufo.peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end)

  local builtin = require "statuscol.builtin"
  require("statuscol").setup {
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      { text = { "%s" }, click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  }

  -- Disable automatic fold all for open a new buffer, ref: https://github.com/kevinhwang91/nvim-ufo/issues/83
  local function applyFoldsAndThenCloseAllFolds(bufnr, providerName)
    require "async"(function()
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      -- make sure buffer is attached
      require("ufo").attach(bufnr)
      -- getFolds return Promise if providerName == 'lsp'
      local ok, ranges = pcall(await, require("ufo").getFolds(bufnr, providerName))
      if ok and ranges then
        ok = require("ufo").applyFolds(bufnr, ranges)
        if ok then
          require("ufo").closeAllFolds()
        end
      else
        local ranges = await(require("ufo").getFolds(bufnr, "indent"))
        local ok = require("ufo").applyFolds(bufnr, ranges)
        if ok then
          require("ufo").closeAllFolds()
        end
      end
    end)
  end

  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function(e)
      applyFoldsAndThenCloseAllFolds(e.buf, "lsp")
    end,
  })
end

return M
