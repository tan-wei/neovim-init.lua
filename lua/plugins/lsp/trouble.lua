local M = {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
}

-- TODO: This plugin should write more configurations
M.opts = {
  modes = {
    mydiags = {
      mode = "diagnostics", -- inherit from diagnostics mode
      filter = {
        any = {
          buf = 0, -- current buffer
          {
            severity = vim.diagnostic.severity.ERROR, -- errors only
            -- limit to files in the current project
            function(item)
              return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
            end,
          },
        },
      },
    },
  },
}

return M
