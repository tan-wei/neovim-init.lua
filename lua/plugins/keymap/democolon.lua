---@type LazyPluginSpec
local M = {
  "mawkler/demicolon.nvim",
  event = "BufReadPost",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-neotest/neotest",
  },
}

-- TODO: Add custom keymaps for other plugins
M.opts = {
  keymaps = {
    horizontal_motions = false,
    diagnostic_motions = true,
    repeat_motions = "stateful",
    list_motions = true,
    spell_motions = true,
    fold_motions = true,
  },
}

M.config = function(_, opts)
  require("demicolon").setup(opts)

  local jump = require("demicolon.jump")

  local function set_neotest_jump(lhs, forward, jump_opts, desc)
    vim.keymap.set("n", lhs, function()
      jump.repeatably_do(function(repeat_opts)
        local direction = repeat_opts.forward and "next" or "prev"
        require("neotest").jump[direction](jump_opts)
      end, { forward = forward })
    end, { desc = desc })
  end

  set_neotest_jump("]t", true, nil, "Next test")
  set_neotest_jump("[t", false, nil, "Previous test")
  set_neotest_jump("]T", true, { status = "failed" }, "Next failed test")
  set_neotest_jump("[T", false, { status = "failed" }, "Previous failed test")
end

-- Custom jumps example (uncomment to use)
-- local jump = require("demicolon.jump")
-- vim.keymap.set("n", "<leader>s", function()
--   jump.repeatably_do(function(opts)
--     require("flash").jump({
--       forward = opts.forward,
--     })
--   end, { forward = true })
-- end, { desc = "Flash jump (repeatable)" })

return M
