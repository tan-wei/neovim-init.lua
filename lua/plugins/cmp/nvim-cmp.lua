local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "chrisgrieser/cmp-nerdfont",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lua",
    "lukas-reineke/cmp-rg",
    "ray-x/cmp-treesitter",
    "amarakon/nvim-cmp-fonts",
    "saadparwaiz1/cmp_luasnip",
    "kristijanhusak/vim-dadbod-completion",
    "lukas-reineke/cmp-under-comparator",
    "onsails/lspkind.nvim",
    "xzbdmw/colorful-menu.nvim",
    "L3MON4D3/LuaSnip",
    "dmitmel/cmp-cmdline-history",
    "SergioRibera/cmp-dotenv",
    {
      "petertriho/cmp-git",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("cmp_git").setup()
      end,
    },
    {
      "paopaol/cmp-doxygen",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    {
      "f3fora/cmp-spell",
    },
    "davidsierradz/cmp-conventionalcommits",
  },
  event = { "InsertEnter", "CmdlineEnter" },
}

M.config = function()
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local lspkind = require "lspkind"

  local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end

  local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = " ",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
    Misc = " ",
  }
  -- find more here: https://www.nerdfonts.com/cheat-sheet

  local default_cmp_sources = cmp.config.sources {
    { name = "nvim_lsp" },
    -- { name = "nvim_lsp_signature_help" }, -- NOTE: May cause duplicated information
    { name = "luasnip" },
    { name = "buffer", dup = 0 },
    { name = "path" },
    { name = "calc" },
    { name = "nvim_lua" },
    { name = "emoji" },
    { name = "nerdfont" },
    { name = "treesitter", group_index = 2 },
    { name = "rg", keyword_length = 3, dup = 0 },
    { name = "dotenv" },
    { name = "git" },
    { name = "doxygen" },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return require("cmp.config.context").in_treesitter_capture "spell"
        end,
        preselect_correct_word = true,
      },
      dup = 0,
    },
  }

  local quoted_name = function(name)
    return "»" .. name .. "«"
  end

  local buf_is_options_lua = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local enable_filename = "options.lua"
    return bufname:sub(-#enable_filename) == enable_filename
  end

  local buf_is_ginit_vim = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local enable_filename = "ginit.vim"
    return bufname:sub(-#enable_filename) == enable_filename
  end

  local buf_is_cargo_toml = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local enable_filename = "Cargo.toml"
    return bufname:sub(-#enable_filename) == enable_filename
  end

  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(t)
      local sources = default_cmp_sources

      if buf_is_options_lua(t.buf) or buf_is_ginit_vim(t.buf) then
        sources[#sources + 1] = { name = "fonts", option = { space_filter = "-" } }
      end

      if buf_is_cargo_toml(t.buf) then
        sources[#sources + 1] = { name = "crates" }
      end

      cmp.setup.buffer {
        sources = sources,
      }
    end,
  })

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },

    sorting = {
      comparators = {
        cmp.config.compare.kind,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        require "clangd_extensions.cmp_scores",
        require("cmp-under-comparator").under,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = lspkind.cmp_format {
        mode = "text_symbol",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        -- The function below will be called before any actual modifications from lspkind
        -- so that we can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          -- Remove duplicate when the source is from rg and buffer
          if entry.source.name == "rg" or entry.source.name == "buffer" or entry.source.name == "spell" then
            vim_item.dup = nil
          end
          vim_item.menu = ({
            nvim_lsp = quoted_name "LSP",
            nvim_lsp_signature_help = quoted_name "LSP_SIGNATURE",
            treesitter = quoted_name "TREESITTER",
            luasnip = quoted_name "SNIPPET",
            buffer = quoted_name "BUFFER",
            path = quoted_name "PATH",
            nvim_lua = quoted_name "NVIM_LUA",
            nerdfont = quoted_name "NERD_FONT",
            emoji = quoted_name "EMOJI",
            rg = quoted_name "RG",
            fonts = quoted_name "FONT",
            crates = quoted_name "CRATES",
            calc = quoted_name "CALC",
            cmdline_history = quoted_name "CMD_HISTORY",
            dotenv = quoted_name "DOTENV",
            git = quoted_name "GIT",
            doxygen = quoted_name "DOXYGEN",
            spell = quoted_name "SPELL",
          })[entry.source.name]

          local highlights_info = require("colorful-menu").cmp_highlights(entry)

          if highlights_info ~= nil then
            vim_item.abbr_hl_group = highlights_info.highlights
            vim_item.abbr = highlights_info.text
          end

          return vim_item
        end,
      },
    },
    sources = default_cmp_sources,
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
    },
    experimental = {
      ghost_text = true,
      native_menu = false,
    },
  }

  -- `/` cmdline setup.
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "nvim_lsp_document_symbol" },
      { name = "buffer" },
      -- { name = "cmdline_history" },
    },
  })

  -- `?` cmdline setup.
  cmp.setup.cmdline("?", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "nvim_lsp_document_symbol" },
      { name = "buffer" },
      -- { name = "cmdline_history" },
    },
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      -- { name = "cmdline_history" },
    }, {
      {
        name = "cmdline",
        option = {
          ignore_cmds = { "Man", "!" },
        },
      },
    }),
  })

  -- Set conifguration for specific filetype
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources {
      { name = "git" },
      { name = "conventionalcommits" },
    },
  })
end

return M
