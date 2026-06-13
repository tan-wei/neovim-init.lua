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
    repeat_motions = false,
    list_motions = true,
    spell_motions = true,
    fold_motions = true,
  },
}

M.config = function(_, opts)
  require("demicolon").setup(opts)

  local jump = require "demicolon.jump"
  local nxo = { "n", "x", "o" }

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

  -- Credit: https://github.com/mawkler/demicolon.nvim/issues/11#issuecomment-2821882735
  local flash_char = require "flash.plugins.char"
  ---@param options { key: string, fowrard: boolean }
  local function flash_jump(options)
    return function()
      require("demicolon.jump").repeatably_do(function(o)
        local key = o.forward and o.key:lower() or o.key:upper()

        flash_char.jumping = true
        local autohide = require("flash.config").get("char").autohide

        -- Originally was
        -- if require("flash.repeat").is_repeat then
        if o.repeated then
          flash_char.jump_labels = false

          -- Originally was
          -- flash_char.state:jump({ count = vim.v.count1 })
          if o.forward then
            flash_char.right()
          else
            flash_char.left()
          end

          flash_char.state:show()
        else
          flash_char.jump(key)
        end

        vim.schedule(function()
          flash_char.jumping = false
          if flash_char.state and autohide then
            flash_char.state:hide()
          end
        end)
      end, options)
    end
  end

  vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "InsertEnter" }, {
    group = vim.api.nvim_create_augroup("flash_char", { clear = true }),
    callback = function(event)
      local hide = event.event == "InsertEnter" or not flash_char.jumping
      if hide and flash_char.state then
        flash_char.state:hide()
      end
    end,
  })

  vim.on_key(function(key)
    if flash_char.state and key == require("flash.util").ESC and (vim.fn.mode() == "n" or vim.fn.mode() == "v") then
      flash_char.state:hide()
    end
  end)

  vim.keymap.set(nxo, "f", flash_jump { key = "f", forward = true }, { desc = "Flash f" })
  vim.keymap.set(nxo, "F", flash_jump { key = "F", forward = false }, { desc = "Flash F" })
  vim.keymap.set(nxo, "t", flash_jump { key = "t", forward = true }, { desc = "Flash t" })
  vim.keymap.set(nxo, "T", flash_jump { key = "T", forward = false }, { desc = "Flash T" })
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
