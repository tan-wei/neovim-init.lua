local M = {
  "shellRaining/hlchunk.nvim",

  event = { "CursorHold", "CursorHoldI" },
}

M.config = function()
  -- NOTE: See: https://github.com/shellRaining/hlchunk.nvim/discussions/22
  require("hlchunk").setup {
    chunk = {
      enable = true,
      use_treesitter = true,
      chars = {
        horizontal_line = "",
        left_top = "󱩡",
        vertical_line = "",
        left_bottom = "",
        right_arrow = "",
        -- horizontal_line = "─",
        -- vertical_line = "│",
        -- left_top = "╭",
        -- left_bottom = "╰",
        -- right_arrow = ">",
      },
      style = "#ffc2e2",
    },
    line_num = {
      enable = true,
      use_treesitter = true,
      style = "#adb5bd",
    },
    blank = { enable = false },
    indent = { enable = false },
  }
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    -- group = curfile_augroup,
    pattern = "*",
    callback = function()
      pcall(vim.cmd, "EnableHLChunk")
      pcall(vim.cmd, "EnableHLLineNum")
    end,
  })
end

return M
