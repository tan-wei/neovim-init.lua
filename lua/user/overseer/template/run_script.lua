local function get_code_runner_command()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or vim.bo.buftype ~= "" then
    return nil
  end

  local ok, code_runner = pcall(require, "code_runner")
  if not ok or type(code_runner.get_filetype_command) ~= "function" then
    return nil
  end

  local ok_cmd, cmd = pcall(code_runner.get_filetype_command)
  if not ok_cmd or cmd == nil or cmd == "" then
    return nil
  end

  return {
    cmd = cmd,
    cwd = vim.fs.dirname(file),
  }
end

---@type overseer.TemplateFileProvider
return {
  name = "user.run_script",
  generator = function()
    if not get_code_runner_command() then
      return {}
    end

    return {
      {
        name = "run current file",
        aliases = { "run script" },
        builder = function()
          local runner = get_code_runner_command()
          if not runner then
            error(string.format("No code_runner command configured for filetype '%s'", vim.bo.filetype))
          end

          return {
            cmd = runner.cmd,
            cwd = runner.cwd,
            components = {
              { "on_output_quickfix", set_diagnostics = true },
              "on_result_diagnostics",
              "default",
            },
          }
        end,
      },
    }
  end,
}
