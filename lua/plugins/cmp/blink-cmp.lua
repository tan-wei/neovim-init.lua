local M = {
  "saghen/blink.cmp",
  cond = function()
    return vim.g.completion_engine == "blink"
  end,
  version = "1.*",
  dependencies = {
    -- Snippet engine (reuse existing LuaSnip)
    "L3MON4D3/LuaSnip",

    -- blink.compat: compatibility layer for nvim-cmp sources
    {
      "saghen/blink.compat",
      version = "2.*",
      lazy = true,
      opts = {},
    },

    -- Native blink community sources
    "giuxtaposition/blink-cmp-copilot", -- copilot
    "moyiz/blink-emoji.nvim", -- emoji
    "MahanRahmati/blink-nerdfont.nvim", -- nerdfont
    "niuiic/blink-cmp-rg.nvim", -- ripgrep
    "ribru17/blink-cmp-spell", -- spell
    "Kaiser-Yang/blink-cmp-git", -- git
    "disrupted/blink-cmp-conventional-commits", -- conventional commits

    -- ecolog.nvim: reads .env files and provides completions (native blink support)
    {
      "ph1losof/ecolog.nvim",
      branch = "v1",
      lazy = false,
      opts = {
        integrations = {
          blink_cmp = true,
          nvim_cmp = false,
        },
      },
    },

    -- nvim-cmp sources used via blink.compat
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-nvim-lua",
    "amarz45/nvim-cmp-fonts",
    "hrsh7th/cmp-nvim-lsp-document-symbol",

    -- dadbod (has native blink support)
    "kristijanhusak/vim-dadbod-completion",

    -- Copilot
    "zbirenbaum/copilot.lua",

    -- Colorful menu (supports blink.cmp natively)
    "xzbdmw/colorful-menu.nvim",
  },
  event = { "InsertEnter", "CmdlineEnter" },
}

M.config = function()
  require("blink.cmp").setup {
    -- Use LuaSnip as snippet engine
    snippets = { preset = "luasnip" },

    -- Keymap: match nvim-cmp behavior
    -- nvim-cmp uses: C-k/C-j (prev/next), CR (accept), Tab/S-Tab (next/prev + snippet),
    -- C-b/C-f (scroll docs), C-Space (complete), C-e (abort)
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = " ",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = " ",
      },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      menu = {
        draw = {
          -- Use colorful-menu.nvim for treesitter-highlighted labels
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return { { group = ctx.kind_hl, priority = 20000 } }
              end,
            },
            label = {
              width = { fill = true, max = 50 },
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return "»" .. ctx.source_name .. "«"
              end,
              highlight = "BlinkCmpSource",
            },
          },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
    },

    signature = {
      enabled = true,
    },

    -- Sources configuration
    sources = {
      default = {
        "lsp",
        "snippets",
        "buffer",
        "path",
        "calc",
        "nvim_lua",
        "emoji",
        "nerdfont",
        "rg",
        "ecolog",
        "git",
        "spell",
        "copilot",
      },
      per_filetype = {
        gitcommit = { inherit_defaults = true, "conventional_commits" },
        sql = { inherit_defaults = true, "dadbod" },
      },
      providers = {
        -- Built-in sources with customized settings
        lsp = {
          name = "LSP",
          fallbacks = {}, -- always show buffer alongside LSP
          score_offset = 10,
        },
        buffer = {
          name = "Buffer",
          score_offset = -3,
        },
        snippets = {
          name = "Snippet",
          score_offset = -1,
        },
        path = {
          name = "Path",
          score_offset = 3,
        },

        -- Native blink community sources
        copilot = {
          name = "Copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
        emoji = {
          name = "Emoji",
          module = "blink-emoji",
          score_offset = -5,
        },
        nerdfont = {
          name = "Nerdfont",
          module = "blink-nerdfont",
          score_offset = -5,
        },
        rg = {
          name = "RG",
          module = "blink-cmp-rg",
          score_offset = -5,
          min_keyword_length = 3,
          async = true,
        },
        spell = {
          name = "Spell",
          module = "blink-cmp-spell",
          score_offset = -5,
        },
        git = {
          name = "Git",
          module = "blink-cmp-git",
          score_offset = -2,
          enabled = function()
            return vim.tbl_contains({ "gitcommit", "octo", "NeogitCommitMessage" }, vim.bo.filetype)
          end,
        },
        conventional_commits = {
          name = "Conventional Commits",
          module = "blink-cmp-conventional-commits",
          score_offset = 5,
          enabled = function()
            return vim.bo.filetype == "gitcommit"
          end,
        },

        -- nvim-cmp sources via blink.compat
        calc = {
          name = "calc",
          module = "blink.compat.source",
          score_offset = -3,
        },
        ecolog = {
          name = "ecolog",
          module = "ecolog.integrations.cmp.blink_cmp",
          score_offset = -5,
        },
        nvim_lua = {
          name = "nvim_lua",
          module = "blink.compat.source",
          score_offset = -3,
        },

        -- dadbod has native blink support
        dadbod = {
          name = "Dadbod",
          module = "vim_dadbod_completion.blink",
          score_offset = 5,
        },
      },
    },

    -- Cmdline configuration
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" or type == "@" then
          return { "cmdline", "path" }
        end
        return {}
      end,
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        ghost_text = { enabled = true },
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  }
end

return M
