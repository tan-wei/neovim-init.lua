local M = {}

local templates = {
  { name = "Empty", directory = "empty" },
  { name = "C (GDB / CMake)", directory = "c-gdb" },
  { name = "C (CodeLLDB / CMake)", directory = "c-lldb" },
  { name = "C++ (GDB / CMake)", directory = "cpp-gdb" },
  { name = "C++ (CodeLLDB / CMake)", directory = "cpp-lldb" },
  { name = "Python (debugpy)", directory = "python" },
  { name = "Rust (CodeLLDB / Cargo)", directory = "rust" },
  { name = "Go (Delve)", directory = "go" },
  { name = "JavaScript (Node.js)", directory = "javascript" },
  { name = "TypeScript (Node.js / tsx)", directory = "typescript" },
  { name = "Lua (Neovim / OSV attach)", directory = "lua" },
  { name = "Lua (standalone / Lua 5.3)", directory = "lua-standalone" },
  { name = "Ruby (rdbg)", directory = "ruby" },
  { name = "Bash (bashdb)", directory = "bash" },
}

local function prepare(filename, lines)
  local existing = vim.fn.bufnr(filename)
  if vim.uv.fs_stat(filename) or existing ~= -1 then
    return existing ~= -1 and existing or vim.fn.bufadd(filename), false
  end

  local buffer = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buffer, filename)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].filetype = "jsonc"
  vim.bo[buffer].modified = true
  return buffer, true
end

function M.create()
  local project = vim.fn.getcwd()
  vim.ui.select(templates, {
    prompt = "Debug configuration template",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if not choice then
      return
    end

    local target = vim.fs.joinpath(project, ".vscode")
    local source = vim.fs.joinpath(vim.fn.stdpath "config", "templates", "debug", choice.directory)
    vim.fn.mkdir(target, "p")
    local launch, new_launch =
      prepare(vim.fs.joinpath(target, "launch.json"), vim.fn.readfile(vim.fs.joinpath(source, "launch.json")))
    local _, new_tasks =
      prepare(vim.fs.joinpath(target, "tasks.json"), vim.fn.readfile(vim.fs.joinpath(source, "tasks.json")))
    vim.cmd.buffer(launch)
    if new_launch or new_tasks then
      vim.notify("Prepared unsaved project debug configs (edit, then :write each file)", vim.log.levels.INFO)
    end
  end)
end

return M
