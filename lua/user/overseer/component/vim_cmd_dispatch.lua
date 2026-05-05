---@type overseer.ComponentFileDefinition
return {
  desc = "Dispatch a Vim command and dispose the wrapper task",
  editable = false,
  serializable = false,
  params = {
    command = {
      type = "string",
    },
  },
  constructor = function(params)
    return {
      on_pre_start = function(self, task)
        vim.schedule(function()
          local ok, err = pcall(vim.cmd, params.command)
          if not ok then
            vim.notify("Failed to dispatch " .. params.command .. ": " .. tostring(err), vim.log.levels.ERROR)
          end

          if not task:is_disposed() then
            task:dispose(true)
          end
        end)

        return false
      end,
    }
  end,
}
