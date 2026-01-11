local M = {
  "clabby/difftastic.nvim",
  cmd = {
    "Difft",
    "DifftClose",
  },
}

M.config = function()
  require("difftastic-nvim").setup {
    download = true,
    vcs = "git",
    highlight_mode = "treesitter",
    keymaps = {
      -- next_file = "]f",
      -- prev_file = "[f",
      -- next_hunk = "]c",
      -- prev_hunk = "[c",
      -- close = "q",
      -- focus_tree = "<Tab>",
      -- focus_diff = "<Tab>",
      -- select = "<CR>",
      -- goto_file = "gf",
    },
  }
end

return M
