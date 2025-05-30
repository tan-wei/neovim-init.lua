local M = {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    { "kkharji/sqlite.lua", module = "sqlite" },
  },
  event = "VeryLazy",
}

M.config = function()
  local function is_whitespace(line)
    return vim.fn.match(line, [[^\s*$]]) ~= -1
  end

  local function all(tbl, check)
    for _, entry in ipairs(tbl) do
      if not check(entry) then
        return false
      end
    end
    return true
  end
  require("neoclip").setup {
    filter = function(data)
      return not all(data.event.regcontents, is_whitespace)
    end,
  }
  require("telescope").load_extension "neoclip"
end

return M
