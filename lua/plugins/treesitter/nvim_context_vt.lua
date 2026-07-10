---@type LazyPluginSpec
local M = {
  "andersevenrud/nvim_context_vt",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.config = function()
  local ignore_node_types = {
    comment = true,
    line_comment = true,
    block_comment = true,
    expression_statement = true,
    declaration = true,
    return_statement = true,
    break_statement = true,
    continue_statement = true,
    preproc_include = true,
    preproc_def = true,
    preproc_if = true,
    template_declaration = true,
    assignment_statement = true,
    call_expression = true,
  }

  require("nvim_context_vt").setup {
    enabled = true,
    prefix = " ➜",
    highlight = "NonText",
    disable_ft = {
      "markdown",
      "csv",
      "tsv",
      "help",
      "man",
      "text",
      "lazy",
      "NvimTree",
      "qf",
      "toggleterm",
      "gitcommit",
    },
    disable_virtual_lines = false,
    disable_virtual_lines_ft = {
      "yaml",
      "python",
    },
    min_rows = 3,
    min_rows_ft = {
      python = 4,
      lua = 4,
    },
    custom_parser = function(node, ft, opts)
      local utils = require "nvim_context_vt.utils"
      if ignore_node_types[node:type()] then
        return nil
      end

      local text = (utils.get_node_text(node)[1] or ""):gsub("^%s*(.-)%s*$", "%1")

      if #text > 80 then
        text = text:sub(1, 60) .. "..."
      end
      return opts.prefix .. " " .. text
    end,

    custom_validator = function(node, ft, opts)
      local default_validator = require("nvim_context_vt.utils").default_validator
      if not default_validator(node, ft, opts) then
        return false
      end

      local node_type = node:type()

      if node_type == "function" or node_type == "method_definition" or node_type == "arrow_function" then
        return false
      end

      if node_type == "if_statement" or node_type == "for_statement" or node_type == "while_statement" then
        local child_count = node:child_count()
        if child_count < 986 then
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
