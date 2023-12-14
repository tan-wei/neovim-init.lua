local M = {
  "pocco81/auto-save.nvim",
  ft = {
    -- "markdown",
    "tex",
    "org",
    "txt",
  },
}

M.config = function()
  local auto_save_fts = {
    -- "markdown",
    "tex",
    "org",
    "txt",
  }

  require("auto-save").setup {
    enabled = true,
    execution_message = {
      message = function()
        return ("AutoSave: saved at " .. vim.fn.strftime "%H:%M:%S")
      end,
      dim = 0.18,
      cleaning_interval = 1250,
    },
    trigger_events = { "InsertLeave" },

    condition = function(buf)
      local fn = vim.fn
      local utils = require "auto-save.utils.data"

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.set_of(auto_save_fts)[fn.getbufvar(buf, "&filetype")] then
        local undotree = fn.undotree()
        if undotree.seq_last ~= undotree.seq_cur then
          return false
        end
        return true
      end

      return false
    end,
    write_all_buffers = false,
    debounce_delay = 135,
    callbacks = {
      enabling = nil,
      disabling = nil,
      before_asserting_save = nil,
      before_saving = nil,
      after_saving = nil,
    },
  }
end

return M
