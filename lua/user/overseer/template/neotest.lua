local overseer = require "overseer"

local function build_template(name, command, aliases)
  return {
    name = name,
    aliases = aliases,
    tags = { overseer.TAG.TEST },
    builder = function()
      return {
        name = name,
        cmd = { vim.v.progpath, "--version" },
        components = {
          { "user.vim_cmd_dispatch", command = command },
        },
        ephemeral = true,
      }
    end,
  }
end

---@type overseer.TemplateFileProvider
return {
  name = "user.neotest",
  generator = function(search)
    return {
      build_template("neotest run", "Neotest run", { "Neotest: Nearest" }),
      build_template("neotest run file", "Neotest run file", { "Neotest: File" }),
      build_template("neotest run last", "Neotest run last", { "Neotest: Last" }),
    }
  end,
}
