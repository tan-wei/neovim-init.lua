local M = {
  "andersevenrud/nvim_context_vt",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.config = function()
  local ignore_node_types = {
    -- ["function"] = true,
    -- expression_statement = true,
    -- declaration = true,
    -- using_declaration = true,
    -- return_statement = true,
    -- preproc_include = true,
    comment = true,
    line_comment = true,
  }

  require("nvim_context_vt").setup {
    enabled = true,
    prefix = "",
    highlight = "CustomContextVt",
    disable_ft = {
      "markdown",
    },
    disable_virtual_lines = false,
    disable_virtual_lines_ft = {
      "yaml",
      "python",
    },
    min_rows = 1,
    min_rows_ft = {},
    custom_parser = function(node, ft, opts)
      local utils = require "nvim_context_vt.utils"
      if ignore_node_types[node:type()] then
        return nil
      end

      return opts.prefix .. " " .. (utils.get_node_text(node)[1] or "")
    end,

    custom_validator = function(node, ft, opts)
      local default_validator = require("nvim_context_vt.utils").default_validator
      if default_validator(node, ft, opts) then
        if node:type() == "function" then
          return false
        end
      end

      return true
    end,

    custom_resolver = function(nodes, ft, opts)
      return nodes[#nodes]
    end,
  }
end

return M
