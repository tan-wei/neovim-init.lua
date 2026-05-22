---@type LazyPluginSpec
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
      augend.constant.new {
        elements = { "false", "true" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.new {
        elements = { "no", "yes" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.new {
        elements = { "off", "on" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.alias.alpha,
      augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%m/%d/%Y"],
      augend.date.alias["%d/%m/%Y"],
      augend.date.alias["%m/%d/%y"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%H:%M:%S"],
      augend.date.alias["%H:%M"],
      augend.constant.new {
        elements = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" },
        word = true,
        cyclic = true,
      },
      augend.constant.new {
        elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
        word = true,
        cyclic = true,
      },
    },
    visual = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.constant.new {
        elements = { "false", "true" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.new {
        elements = { "no", "yes" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.new {
        elements = { "off", "on" },
        cyclic = false,
        preserve_case = true,
      },
      augend.constant.alias.alpha,
      augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%m/%d/%Y"],
      augend.date.alias["%d/%m/%Y"],
      augend.date.alias["%m/%d/%y"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%H:%M:%S"],
      augend.date.alias["%H:%M"],
      augend.constant.new {
        elements = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" },
        word = true,
        cyclic = true,
      },
      augend.constant.new {
        elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
        word = true,
        cyclic = true,
      },
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
      augend.constant.alias.bool,
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
