local M = {
  "okuuva/auto-save.nvim",
  ft = {
    -- "markdown",
    "tex",
    "org",
    "txt",
  },
  cmd = "ASToggle",
}

M.config = function()
  require("auto-save").setup {
    enabled = true,
    execution_message = {
      message = function()
        return ("AutoSave: saved at " .. vim.fn.strftime "%H:%M:%S")
      end,
      dim = 0.18,
      cleaning_interval = 1250,
    },
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_defered_save = { "InsertEnter" },
    },
    condition = function(buf)
      local fn = vim.fn
      local utils = require "auto-save.utils.data"

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.set_of(M.ft)[fn.getbufvar(buf, "&filetype")] then
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
    noautocmd = false,
    lockmarks = false,
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
