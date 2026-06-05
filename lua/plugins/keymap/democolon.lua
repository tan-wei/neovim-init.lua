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

  local jump = require "demicolon.jump"
  local nxo = { "n", "x", "o" }

  local function flash_char_jump(key)
    local flash_char = require "flash.plugins.char"
    local autohide = require("flash.config").get("char").autohide

    flash_char.jumping = true
    flash_char.jump(key)

    vim.schedule(function()
      flash_char.jumping = false
      if flash_char.state and autohide then
        flash_char.state:hide()
      end
    end)
  end

  local function set_flash_char_jump(lhs)
    local motion_is_forward = lhs == "f" or lhs == "t"

    vim.keymap.set(nxo, lhs, function()
      jump.repeatably_do(function(repeat_opts)
        if repeat_opts.repeated then
          local repeat_key = repeat_opts.forward == motion_is_forward and ";" or ","
          flash_char_jump(repeat_key)
          return
        end

        flash_char_jump(lhs)
      end, { forward = motion_is_forward })
    end, { desc = "Flash " .. lhs })
  end

  local function set_neotest_jump(lhs, forward, jump_opts, desc)
    vim.keymap.set("n", lhs, function()
      jump.repeatably_do(function(repeat_opts)
        local direction = repeat_opts.forward and "next" or "prev"
        require("neotest").jump[direction](jump_opts)
      end, { forward = forward })
    end, { desc = desc })
  end

  local function set_portal_jump(lhs, builtin_name, forward, desc)
    vim.keymap.set("n", lhs, function()
      jump.repeatably_do(function(repeat_opts)
        local direction = repeat_opts.forward and "forward" or "backward"
        vim.cmd(("Portal %s %s"):format(builtin_name, direction))
      end, { forward = forward })
    end, { desc = desc })
  end

  set_neotest_jump("]t", true, nil, "Next test")
  set_neotest_jump("[t", false, nil, "Previous test")
  set_neotest_jump("]T", true, { status = "failed" }, "Next failed test")
  set_neotest_jump("[T", false, { status = "failed" }, "Previous failed test")

  set_portal_jump("<leader>jj", "jumplist", true, "jump forward")
  set_portal_jump("<leader>jk", "jumplist", false, "jump backward")
  set_portal_jump("<leader>jcj", "changelist", true, "jump Changelist forward")
  set_portal_jump("<leader>jck", "changelist", false, "jump Changelist backward")
  set_portal_jump("<leader>jgj", "grapple", true, "jump Grapple forward")
  set_portal_jump("<leader>jgk", "grapple", false, "jump Grapple backward")
  set_portal_jump("<leader>jhj", "harpoon", true, "jump Harpoon forward")
  set_portal_jump("<leader>jhk", "harpoon", false, "jump Harpoon backward")
  set_portal_jump("<leader>jqj", "quickfix", true, "jump Quickfix forward")
  set_portal_jump("<leader>jqk", "quickfix", false, "jump Quickfix backward")

  set_flash_char_jump "f"
  set_flash_char_jump "F"
  set_flash_char_jump "t"
  set_flash_char_jump "T"
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
