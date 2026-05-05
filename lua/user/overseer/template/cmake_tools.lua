local overseer = require "overseer"

local function find_cmake_root(dir)
  local start_dir = dir or vim.fn.getcwd()
  return vim.fs.root(start_dir, { "CMakeLists.txt" })
end

local function build_template(name, command, tags, aliases)
  return {
    name = name,
    aliases = aliases,
    tags = tags,
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
  name = "user.cmake_tools",
  cache_key = function(search)
    return find_cmake_root(search.dir)
  end,
  generator = function(search)
    local root = find_cmake_root(search.dir)
    if not root then
      return {}
    end

    return {
      build_template("cmake generate", "CMakeGenerate", { overseer.TAG.BUILD }, { "CMake: Generate" }),
      build_template("cmake build", "CMakeBuild", { overseer.TAG.BUILD }, { "CMake: Build" }),
      build_template("cmake run", "CMakeRun", { overseer.TAG.RUN }, { "CMake: Run" }),
      build_template("cmake test", "CMakeRunTest", { overseer.TAG.TEST }, { "CMake: Test" }),
    }
  end,
}
