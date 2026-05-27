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

  npairs.setup {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt" },
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


  npairs.add_rules {
    -- LaTeX: $$ only pairs inside strings/comments
    Rule("$", "$", "latex"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
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
