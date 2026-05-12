local log = require "overseer.log"
local overseer = require "overseer"

---@param name string
---@return boolean
local function is_justfile(name)
  name = name:lower()
  return name == "justfile" or name == ".justfile"
end

---@param value any
---@return boolean
local function has_default(value)
  return value ~= nil and value ~= vim.NIL
end

---@param value any
---@return boolean
local function is_literal_default(value)
  local value_type = type(value)
  return value_type == "string" or value_type == "number" or value_type == "boolean"
end

---@param value any
---@return boolean
local function has_explicit_value(value)
  return value ~= nil and value ~= vim.NIL
end

---@param param table
---@return nil|string
local function get_long_option(param)
  if not has_explicit_value(param.long) then
    return nil
  end
  local long_name = tostring(param.long)
  if long_name == "true" or long_name == "" then
    long_name = param.name
  end
  return "--" .. long_name
end

---@param param table
---@return nil|string
local function get_short_option(param)
  if not has_explicit_value(param.short) then
    return nil
  end
  return "-" .. tostring(param.short)
end

---@param param table
---@return nil|string
local function get_preferred_option(param)
  return get_long_option(param) or get_short_option(param)
end

---@param param table
---@return nil|string
local function get_option_synopsis(param)
  local long_opt = get_long_option(param)
  local short_opt = get_short_option(param)
  if long_opt and short_opt then
    return string.format("%s or %s", long_opt, short_opt)
  end
  return long_opt or short_opt
end

---@param param table
---@return boolean
local function is_option_param(param)
  return get_preferred_option(param) ~= nil
end

---@param param table
---@return boolean
local function is_flag_param(param)
  return is_option_param(param) and has_explicit_value(param.value)
end

---@param recipe_namepath string
---@return nil|string
local function get_module_path(recipe_namepath)
  return recipe_namepath:match "^(.*)::[^:]+$"
end

---@param recipe_namepath string
---@param variable_name string
---@return string
local function get_scoped_variable_name(recipe_namepath, variable_name)
  local module_path = get_module_path(recipe_namepath)
  if module_path then
    return module_path .. "::" .. variable_name
  end
  return variable_name
end

---@param param table
---@param value any
---@return any
local function normalize_default_value(param, value)
  if value == nil or value == vim.NIL then
    return nil
  end

  if is_flag_param(param) then
    return tostring(value) == tostring(param.value)
  end

  if param.kind == "singular" then
    return value
  end

  if type(value) == "table" then
    return value
  end

  local text = vim.trim(tostring(value))
  if text == "" then
    return {}
  end
  return vim.split(text, "%s+", { trimempty = true })
end

---@param param table
---@param default_value any
---@return string
local function build_default_desc(param, default_value)
  local option_synopsis = get_option_synopsis(param)
  if is_flag_param(param) then
    local state = default_value and "enabled" or "disabled"
    if option_synopsis then
      return string.format(
        "Pass %s to set %s. Default: %s. Toggle to override.",
        option_synopsis,
        tostring(param.value),
        state
      )
    end
    return string.format("Default: %s. Toggle to override.", state)
  end

  if option_synopsis then
    if param.kind == "singular" then
      return string.format(
        "Pass as %s <value>. Just default: %s. Edit to override.",
        option_synopsis,
        tostring(default_value)
      )
    end
    return string.format(
      "Pass as %s <values>. Just default: %s. Edit to override.",
      option_synopsis,
      table.concat(default_value, " ")
    )
  end

  if param.kind == "singular" then
    return string.format("Just default: %s. Edit to override.", tostring(default_value))
  end
  return string.format("Just default: %s. Edit to override.", table.concat(default_value, " "))
end

---@param justfile string
---@param recipe_namepath string
---@param variable_name string
---@param cache table<string, any>
---@return any
local function evaluate_variable_default(justfile, recipe_namepath, variable_name, cache)
  local scoped_name = get_scoped_variable_name(recipe_namepath, variable_name)
  if cache[scoped_name] ~= nil then
    return cache[scoped_name]
  end

  local result = vim
    .system({ "just", "--justfile=" .. justfile, "--evaluate", scoped_name }, { cwd = vim.fs.dirname(justfile), text = true })
    :wait()

  if result.code ~= 0 then
    log.warn("Failed to evaluate just variable '%s': %s", scoped_name, result.stderr or result.stdout or "")
    cache[scoped_name] = vim.NIL
    return nil
  end

  cache[scoped_name] = vim.trim(result.stdout)
  return cache[scoped_name]
end

---@param justfile string
---@param recipe table
---@param param table
---@param cache table<string, any>
---@return overseer.Param
local function build_param_defn(justfile, recipe, param, cache)
  local defn = {
    type = is_flag_param(param) and "boolean" or (param.kind == "singular" and "string" or "list"),
    delimiter = " ",
  }

  if has_default(param.default) then
    defn.optional = true
    local default_value
    if is_literal_default(param.default) then
      default_value = normalize_default_value(param, param.default)
    elseif type(param.default) == "table" and param.default[1] == "variable" then
      local resolved = evaluate_variable_default(justfile, recipe.namepath, param.default[2], cache)
      default_value = normalize_default_value(param, resolved)
    end

    if default_value ~= nil then
      defn.default = default_value
      defn.desc = build_default_desc(param, default_value)
    else
      local option_synopsis = get_option_synopsis(param)
      if is_flag_param(param) then
        defn.desc = string.format("Set to true to pass %s and assign %s.", option_synopsis, tostring(param.value))
        defn.validate = function(value)
          return value == true
        end
      elseif option_synopsis then
        defn.desc = string.format("Pass as %s.", option_synopsis)
      else
        defn.desc = "Leave empty to use the Just default."
      end
    end
  elseif is_option_param(param) then
    local option_synopsis = get_option_synopsis(param)
    if is_flag_param(param) then
      defn.desc = string.format("Set to true to pass %s and assign %s.", option_synopsis, tostring(param.value))
      defn.validate = function(value)
        return value == true
      end
    else
      defn.desc = string.format("Pass as %s.", option_synopsis)
    end
  end

  return defn
end

---@param cmd string[]
---@param param table
---@param value any
local function append_param_args(cmd, param, value)
  if value == nil or value == "" then
    return
  end

  if is_flag_param(param) then
    if value == true then
      table.insert(cmd, get_preferred_option(param))
    end
    return
  end

  if is_option_param(param) then
    table.insert(cmd, get_preferred_option(param))
  end

  if type(value) == "table" then
    vim.list_extend(cmd, value)
  else
    table.insert(cmd, value)
  end
end

---@param task_list overseer.TemplateDefinition[]
---@param justfile string
---@param cwd string
---@param recipes table
---@param cache table<string, any>
local function add_recipes(task_list, justfile, cwd, recipes, cache)
  for _, recipe in pairs(recipes) do
    if not recipe.private then
      local params_defn = {}
      for index, param in ipairs(recipe.parameters or {}) do
        params_defn[param.name] = build_param_defn(justfile, recipe, param, cache)
        params_defn[param.name].order = index
      end

      table.insert(task_list, {
        name = string.format("just %s", recipe.namepath),
        desc = recipe.doc,
        params = params_defn,
        builder = function(params)
          local cmd = { "just", recipe.namepath }
          for _, param in ipairs(recipe.parameters or {}) do
            append_param_args(cmd, param, params[param.name])
          end
          return {
            cmd = cmd,
            cwd = cwd,
          }
        end,
      })
    end
  end
end

---@param parent table
---@param candidate_module string
---@return boolean
local function includes_module(parent, candidate_module)
  for _, mod in pairs(parent.modules) do
    if mod.source == candidate_module then
      return true
    end
  end
  return false
end

---@param candidates string[]
---@param callback fun(err?: string, data?: table<string, table>)
local function fetch_justfile_data(candidates, callback)
  local cb
  local ret = {}
  local remaining = #candidates
  cb = function(err, justfile, data)
    if err then
      cb = function() end
      callback(err)
    else
      ret[justfile] = data
      remaining = remaining - 1
      if remaining == 0 then
        callback(nil, ret)
      end
    end
  end

  for _, justfile in ipairs(candidates) do
    local cwd = vim.fs.dirname(justfile)
    overseer.builtin.system(
      { "just", "--unstable", "--dump", "--dump-format", "json" },
      {
        cwd = cwd,
        text = true,
      },
      vim.schedule_wrap(function(out)
        if out.code ~= 0 then
          cb(out.stderr or out.stdout or "Error running 'just'")
          return
        end
        local ok, data = pcall(vim.json.decode, out.stdout, { luanil = { object = true } })
        if not ok then
          log.error("just produced invalid json: %s", out.stdout)
          cb(string.format("just produced invalid json: %s\n%s", data))
          return
        end
        cb(nil, justfile, data)
      end)
    )
  end
end

---@type overseer.TemplateProvider
return {
  name = "user.just",
  cache_key = function(opts)
    return vim.fs.find(is_justfile, { upward = true, path = opts.dir })[1]
  end,
  generator = function(opts, cb)
    if vim.fn.executable "just" == 0 then
      return 'Command "just" not found'
    end
    local candidates = vim.fs.find(is_justfile, { upward = true, path = opts.dir, limit = math.huge })
    if vim.tbl_isempty(candidates) then
      return "No justfile found"
    end
    fetch_justfile_data(candidates, function(err, data_map)
      if err then
        cb(err)
        return
      end

      local ret = {}
      local selected_file
      for _, justfile in ipairs(candidates) do
        if not selected_file or includes_module(data_map[justfile], selected_file) then
          selected_file = justfile
        else
          break
        end
      end

      local cwd = vim.fs.dirname(selected_file)
      local data = data_map[selected_file]
      local default_cache = {}
      add_recipes(ret, selected_file, cwd, data.recipes, default_cache)
      if data.modules then
        for _, module in pairs(data.modules) do
          add_recipes(ret, selected_file, cwd, module.recipes or {}, default_cache)
        end
      end
      cb(ret)
    end)
  end,
}
