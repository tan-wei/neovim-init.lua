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

function M.treewalker_jump(axis, forward)
  require("demicolon.jump").repeatably_do(function(repeat_opts)
    local treewalker = require "treewalker"
    local motion = axis == "vertical" and (repeat_opts.forward and "move_down" or "move_up")
      or (repeat_opts.forward and "move_in" or "move_out")
    treewalker[motion]()
  end, { forward = forward })
end

function M.neotest_jump(forward, jump_opts)
  require("demicolon.jump").repeatably_do(function(repeat_opts)
    local direction = repeat_opts.forward and "next" or "prev"
    require("neotest").jump[direction](jump_opts)
  end, { forward = forward })
end

function M.portal_jump(builtin_name, forward)
  require("demicolon.jump").repeatably_do(function(repeat_opts)
    local direction = repeat_opts.forward and "forward" or "backward"
    vim.cmd(("Portal %s %s"):format(builtin_name, direction))
  end, { forward = forward })
end

-- Credit: https://github.com/mawkler/demicolon.nvim/issues/11#issuecomment-2821882735
function M.flash_jump(options)
  require("demicolon.jump").repeatably_do(function(repeat_opts)
    local flash_char = require "flash.plugins.char"
    local key = repeat_opts.forward and repeat_opts.key:lower() or repeat_opts.key:upper()

    flash_char.jumping = true
    local autohide = require("flash.config").get("char").autohide

    if repeat_opts.repeated then
      flash_char.jump_labels = false
      if repeat_opts.forward then
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

M.opts = {
  keymaps = {
    horizontal_motions = false,
    diagnostic_motions = true,
    repeat_motions = "stateful",
    list_motions = true,
    spell_motions = true,
    fold_motions = true,
    disabled_keys = { "p", "I", "A", "f", "i", "[", "]" },
  },
}

M.config = function(_, opts)
  require("demicolon").setup(opts)

  local flash_char = require "flash.plugins.char"

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
end

return M
