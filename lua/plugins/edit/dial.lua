local M = {
  "monaqa/dial.nvim",
  module = true,
}

M.config = function()
  local augend = require "dial.augend"
  local r = true
  require("dial.config").augends:register_group {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
    },
    visual = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
    },
  }
  require("dial.config").augends:on_filetype {
    lua = {
      augend.constant.alias.bool,
    },
    c = {
      augend.constant.alias.bool,
    },
    cpp = {
      augend.ponstant.alias.bool,
    },
    python = {
      augend.constant.new { elements = { "True", "False" } },
    },
    markdown = {
      augend.integer.alias.decimal,
      augend.misc.alias.markdown_header,
    },
  }
end

return M
