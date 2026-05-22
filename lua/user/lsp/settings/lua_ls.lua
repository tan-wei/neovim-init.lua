---@type vim.lsp.Config
local function append_unique(tbl, value)
  if type(tbl) ~= "table" then
    tbl = {}
  end

  if value and value ~= "" and not vim.tbl_contains(tbl, value) then
    table.insert(tbl, value)
  end

  return tbl
end

local M = {
  on_init = function(client)
    local settings = client.config.settings or {}
    local lua_settings = settings.Lua or {}
    local workspace = lua_settings.workspace or {}
    local library = workspace.library
    local lazy_library = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

    library = append_unique(library, vim.env.VIMRUNTIME)
    library = append_unique(library, "${3rd}/luv/library")

    if vim.uv.fs_stat(lazy_library) ~= nil then
      library = append_unique(library, lazy_library)
    end

    client.config.settings = vim.tbl_deep_extend("force", settings, {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        workspace = {
          checkThirdParty = false,
          library = library,
        },
        hint = {
          enable = true,
          setType = true,
        },
        codeLens = {
          enable = true,
        },
      },
    })

    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    return true
  end,
}

return M
