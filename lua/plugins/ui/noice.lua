---@type LazyPluginSpec
local M = {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        local function normal_background_colour()
          local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

          if normal.bg then
            return string.format("#%06x", normal.bg)
          end

          return "#000000"
        end

        local function link_notify_highlights()
          local levels = {
            ERROR = "DiagnosticSignError",
            WARN = "DiagnosticSignWarn",
            INFO = "DiagnosticSignInfo",
            DEBUG = "DiagnosticSignHint",
            TRACE = "DiagnosticSignHint",
          }

          for level, target in pairs(levels) do
            vim.api.nvim_set_hl(0, "Notify" .. level .. "Border", { link = target })
          end
        end

        local function setup_notify()
          require("notify").setup {
            background_colour = normal_background_colour(),
          }
          link_notify_highlights()
        end

        setup_notify()
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = setup_notify,
        })
      end,
    },
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("noice").setup {
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          event = { "msg_show", "notify" },
          cond = function(message)
            local content = message:content()
            return content:find("UnhandledPromiseRejection", 1, true) and content:find("not indexed", 1, true)
          end,
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = false,
    },
  }

  require("telescope").load_extension "noice"
end

return M
