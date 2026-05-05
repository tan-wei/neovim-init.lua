local M = {
  "J-Cowsert/classlayout.nvim",
  cmd = {
    "ClassLayout",
  },
}

M.config = function()
  local compile_commands = require "util.compile_commands"

  local notified_roots = {}

  local function ensure_root_compile_commands(file_path, opts)
    opts = opts or {}

    local root_dir = compile_commands.find_project_root(file_path)
    if not root_dir then
      return false
    end

    local root_compile_commands = vim.fs.normalize(root_dir .. "/compile_commands.json")
    local root_lstat = vim.uv.fs_lstat(root_compile_commands)

    if root_lstat and root_lstat.type ~= "link" then
      notified_roots[root_dir] = "present"
      return true
    end

    if root_lstat and root_lstat.type == "link" then
      local resolved = vim.fn.resolve(root_compile_commands)
      if resolved ~= "" and vim.uv.fs_stat(resolved) ~= nil then
        notified_roots[root_dir] = "present"
        return true
      end

      vim.uv.fs_unlink(root_compile_commands)
    end

    local source_dir = compile_commands.find_compile_commands_dir(root_dir)
    if not source_dir then
      if opts.notify ~= false and notified_roots[root_dir] ~= "missing" then
        vim.notify("ClassLayout: compile_commands.json not found for " .. root_dir, vim.log.levels.WARN)
        notified_roots[root_dir] = "missing"
      end
      return false
    end

    local source_compile_commands = vim.fs.normalize(source_dir .. "/compile_commands.json")
    if source_compile_commands == root_compile_commands then
      notified_roots[root_dir] = "present"
      return true
    end

    local ok, err = vim.uv.fs_symlink(source_compile_commands, root_compile_commands)
    if ok then
      if opts.notify ~= false and notified_roots[root_dir] ~= source_compile_commands then
        vim.notify("ClassLayout: linked compile_commands.json -> " .. source_compile_commands, vim.log.levels.INFO)
      end
      notified_roots[root_dir] = source_compile_commands
      return true
    end

    if opts.notify ~= false and notified_roots[root_dir] ~= "error:" .. tostring(err) then
      vim.notify("ClassLayout: failed to link compile_commands.json: " .. tostring(err), vim.log.levels.ERROR)
      notified_roots[root_dir] = "error:" .. tostring(err)
    end

    return false
  end

  local function ensure_current_buffer_compile_commands()
    ensure_root_compile_commands(vim.api.nvim_buf_get_name(0))
  end

  ensure_current_buffer_compile_commands()

  require("classlayout").setup {
    compiler = "clang",
    compile_commands = true,
  }
    
  local augroup = vim.api.nvim_create_augroup("classlayout-prepare-compile-commands", { clear = true })

  -- vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  --   group = augroup,
  --   desc = "Prepare root compile_commands.json for classlayout",
  --   callback = ensure_current_buffer_compile_commands,
  -- })
end

return M
