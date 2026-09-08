---@type LazyPluginSpec
local M = {
  "windwp/nvim-autopairs",
  dependencies = vim.g.completion_engine ~= "blink" and { "hrsh7th/nvim-cmp" } or {},
  event = "InsertEnter",
}

M.config = function()
  local npairs = require "nvim-autopairs"
  local Rule = require "nvim-autopairs.rule"
  local cond = require "nvim-autopairs.conds"
  local ts_conds = require "nvim-autopairs.ts-conds"
  local ts_get_lang = vim.treesitter.language and vim.treesitter.language.get_lang

  local quote_set = function(...)
    local quotes = {}
    for i = 1, select("#", ...) do
      quotes[select(i, ...)] = true
    end
    return quotes
  end

  local quote_sets = {
    single = quote_set "'",
    double = quote_set '"',
    backtick = quote_set "`",
    single_double = quote_set("'", '"'),
    double_backtick = quote_set('"', "`"),
    single_double_backtick = quote_set("'", '"', "`"),
  }

  local function get_quote_set(quote_char)
    if quote_char == "'" then
      return quote_sets.single
    end
    if quote_char == '"' then
      return quote_sets.double
    end
    if quote_char == "`" then
      return quote_sets.backtick
    end
  end

  local function find_context_node(ctx, ...)
    local node_types = quote_set(...)
    for _, node in ipairs(ctx.nodes) do
      if node_types[node.type] then
        return node
      end
    end
  end

  local function get_treesitter_context(opts)
    local source = opts.text or opts.line
    if source == nil or source == "" then
      return
    end

    -- Parse the post-input line, because an escaped quote is often invalid syntax
    -- until the just-typed quote is included in the Treesitter snapshot.

    local filetype = vim.bo[opts.bufnr].filetype
    local parser_lang = ts_get_lang and ts_get_lang(filetype) or filetype
    if parser_lang == nil or parser_lang == "" then
      return
    end

    local ok, parser = pcall(vim.treesitter.get_string_parser, source, parser_lang)
    if not ok or parser == nil then
      return
    end

    local ok_parse, trees = pcall(parser.parse, parser)
    if not ok_parse or trees == nil or trees[1] == nil then
      return
    end

    local col = math.max((opts.col or 1) - 1, 0)
    local node = trees[1]:root():named_descendant_for_range(0, col, 0, col)
    if parser == nil then
      return
    end
    if node == nil then
      return
    end

    local nodes = {}
    while node ~= nil do
      local start_row, start_col, end_row, end_col = node:range()
      local text = ""
      if start_row == 0 and end_row == 0 then
        text = source:sub(start_col + 1, end_col)
      end
      table.insert(nodes, {
        type = node:type(),
        text = text,
      })
      node = node:parent()
    end

    return {
      nodes = nodes,
    }
  end

  -- Classifiers opt in only for string syntaxes that actually use backslash
  -- escaping. Raw/literal/long-string forms return nil so quotes keep their
  -- normal autopairs behavior there.

  local function classify_c_family_string(ctx)
    if find_context_node(ctx, "raw_string_literal") ~= nil then
      return
    end
    if find_context_node(ctx, "string_literal") ~= nil then
      return "\\", quote_sets.double
    end
    if find_context_node(ctx, "char_literal") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_go_string(ctx)
    if find_context_node(ctx, "raw_string_literal") ~= nil then
      return
    end
    if find_context_node(ctx, "interpreted_string_literal") ~= nil then
      return "\\", quote_sets.double
    end
    if find_context_node(ctx, "rune_literal") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_java_string(ctx)
    if find_context_node(ctx, "string_literal") ~= nil then
      return "\\", quote_sets.double
    end
    if find_context_node(ctx, "character_literal") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_javascript_string(ctx)
    local string_node = find_context_node(ctx, "string")
    if string_node ~= nil then
      local quote_char = string_node.text:sub(1, 1)
      local quotes = get_quote_set(quote_char)
      if quotes ~= nil then
        return "\\", quotes
      end
    end
    if find_context_node(ctx, "template_string") ~= nil then
      return "\\", quote_sets.backtick
    end
  end

  local function classify_lua_string(ctx)
    local string_node = find_context_node(ctx, "string")
    if string_node == nil then
      return
    end
    if string_node.text:match "^%[=*%[" then
      return
    end

    local quote_char = string_node.text:sub(1, 1)
    local quotes = get_quote_set(quote_char)
    if quotes ~= nil then
      return "\\", quotes
    end
  end

  local function classify_python_string(ctx)
    local string_node = find_context_node(ctx, "string")
    local text = string_node and string_node.text or nil
    if text == nil or text == "" then
      return
    end

    local prefix, quote_char = text:match "^([%a]*)(['\"])"
    if quote_char == nil then
      return
    end
    if prefix ~= nil and prefix:lower():find("r", 1, true) ~= nil then
      return
    end

    return "\\", get_quote_set(quote_char)
  end

  local function classify_ruby_string(ctx)
    if find_context_node(ctx, "subshell") ~= nil then
      return "\\", quote_sets.backtick
    end

    local string_node = find_context_node(ctx, "string")
    if string_node == nil then
      return
    end

    local quote_char = string_node.text:sub(1, 1)
    local quotes = get_quote_set(quote_char)
    if quotes ~= nil then
      return "\\", quotes
    end
  end

  local function classify_shell_string(ctx)
    if find_context_node(ctx, "ansi_c_string") ~= nil then
      return "\\", quote_sets.single
    end

    local string_node = find_context_node(ctx, "string")
    if string_node == nil then
      return
    end

    local quote_char = string_node.text:sub(1, 1)
    if quote_char == '"' then
      return "\\", quote_sets.double
    end
    if quote_char == "`" then
      return "\\", quote_sets.backtick
    end
  end

  local function classify_toml_string(ctx)
    local string_node = find_context_node(ctx, "string")
    if string_node == nil then
      return
    end

    if string_node.text:match "^'" then
      return
    end

    if string_node.text:match '^"' then
      return "\\", quote_sets.double
    end
  end

  local function classify_yaml_string(ctx)
    if find_context_node(ctx, "double_quote_scalar") ~= nil then
      return "\\", quote_sets.double
    end
  end

  local function classify_php_string(ctx)
    if find_context_node(ctx, "encapsed_string") ~= nil then
      return "\\", quote_sets.double
    end

    if find_context_node(ctx, "string") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_scala_string(ctx)
    local string_node = find_context_node(ctx, "string")
    if string_node ~= nil then
      if string_node.text:match '^"""' then
        return
      end
      return "\\", quote_sets.double
    end

    if find_context_node(ctx, "character_literal") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_swift_string(ctx)
    if find_context_node(ctx, "line_string_literal") ~= nil then
      return "\\", quote_sets.double
    end
  end

  local function classify_kotlin_string(ctx)
    local string_node = find_context_node(ctx, "string_literal")
    if string_node ~= nil then
      if string_node.text:match '^"""' then
        return
      end
      return "\\", quote_sets.double
    end

    if find_context_node(ctx, "character_literal") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local function classify_zig_string(ctx)
    if find_context_node(ctx, "multiline_string") ~= nil then
      return
    end

    if find_context_node(ctx, "string") ~= nil then
      return "\\", quote_sets.double
    end

    if find_context_node(ctx, "character") ~= nil then
      return "\\", quote_sets.single
    end
  end

  local quote_escape_classifiers = {
    -- Shell-like filetypes: only double quotes and backticks honor backslash
    -- escapes; single quotes remain literal.
    bash = classify_shell_string,
    c = classify_c_family_string,
    cpp = classify_c_family_string,
    cuda = classify_c_family_string,
    go = classify_go_string,
    java = classify_java_string,
    javascript = classify_javascript_string,
    javascriptreact = classify_javascript_string,
    kotlin = classify_kotlin_string,
    json = function(ctx)
      if find_context_node(ctx, "string") ~= nil then
        return "\\", quote_sets.double
      end
    end,
    jsonc = function(ctx)
      if find_context_node(ctx, "string") ~= nil then
        return "\\", quote_sets.double
      end
    end,
    lua = classify_lua_string,
    objc = classify_c_family_string,
    objcpp = classify_c_family_string,
    php = classify_php_string,
    python = classify_python_string,
    ruby = classify_ruby_string,
    rust = function(ctx)
      if find_context_node(ctx, "raw_string_literal") ~= nil then
        return
      end
      if find_context_node(ctx, "string_literal") ~= nil then
        return "\\", quote_sets.double
      end
      if find_context_node(ctx, "char_literal") ~= nil then
        return "\\", quote_sets.single
      end
    end,
    scala = classify_scala_string,
    sh = classify_shell_string,
    swift = classify_swift_string,
    -- TOML/YAML only enable the guard for double-quoted scalars.
    toml = classify_toml_string,
    typescript = classify_javascript_string,
    typescriptreact = classify_javascript_string,
    yaml = classify_yaml_string,
    zig = classify_zig_string,
    zsh = classify_shell_string,
  }

  local function get_rule_quote_char(opts)
    if opts.char ~= nil and opts.char ~= "" then
      return opts.char
    end
    if opts.rule ~= nil then
      return opts.rule.start_pair
    end
  end

  local function get_quote_escape_spec(opts)
    local classifier = quote_escape_classifiers[vim.bo[opts.bufnr].filetype]
    if classifier == nil then
      return
    end

    local ctx = get_treesitter_context(opts)
    if ctx == nil then
      return
    end

    local escape_char, escapable_quotes = classifier(ctx)
    if escape_char == nil or escapable_quotes == nil then
      return
    end

    return {
      escape_char = escape_char,
      escapable_quotes = escapable_quotes,
    }
  end

  local function block_escaped_quote(opts)
    local quote_char = get_rule_quote_char(opts)
    if quote_char == nil then
      return
    end

    local spec = get_quote_escape_spec(opts)
    if spec == nil or not spec.escapable_quotes[quote_char] then
      return
    end

    local count = 0
    local index = opts.col - 1
    while index > 0 and opts.line:sub(index, index) == spec.escape_char do
      count = count + 1
      index = index - 1
    end

    if count % 2 == 1 then
      return false
    end
  end

  npairs.setup {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = {
      "fzf",
      "fzflua_backdrop",
      "qf",
      "help",
      "lazy",
      "mason",
      "checkhealth",
      "noice",
      "notify",
      "NvimTree",
      "Outline",
      "toggleterm",
      "fugitive",
      "neogit",
      "undotree",
      "alpha",
      "trouble",
      "dapui_breakpoint",
      "dapui_stacks",
      "dapui_scopes",
      "dapui_console",
      "dapui_watches",
    },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  }

  for _, quote_char in ipairs { "'", '"', "`" } do
    for _, rule in ipairs(npairs.get_rules(quote_char)) do
      if not rule._contextual_escape_quote_guard then
        -- Guard pair, move-right, and paired deletion with the same contextual
        -- escaped-quote check so all quote interactions stay consistent.
        rule:with_pair(block_escaped_quote, 1)
        rule.move_cond = rule.move_cond or {}
        table.insert(rule.move_cond, 1, block_escaped_quote)
        rule.del_cond = rule.del_cond or {}
        table.insert(rule.del_cond, 1, block_escaped_quote)
        rule._contextual_escape_quote_guard = true
      end
    end
  end

  npairs.add_rules {
    -- LaTeX: $$ only pairs inside strings/comments
    Rule("$", "$", "latex"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
  }

  if vim.g.completion_engine ~= "blink" then
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    require("cmp").event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done {
        map_char = {
          tex = "",
        },
      }
    )
  end
end

return M
