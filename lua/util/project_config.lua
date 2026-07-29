local M = {}

local sections = {
  {
    title = "Project metadata",
    fields = {
      { name = "header_field_project", default = "TODO: Project Name", template = "TODO: Project Name" },
      { name = "templates_guard_prefix", template = "TODO: Template Guard Prefix" },
      { name = "header_field_author", default = "Winterreise", template = "TODO: Author Name" },
      { name = "header_field_author_email", default = "winterreise.tanwei@gmail.com", template = "TODO: Author Email" },
      { name = "header_auto_add_header", default = 0 },
      { name = "header_auto_update_header", default = 1 },
      { name = "header_field_filename", default = 1 },
      { name = "header_field_timestamp", default = 1 },
      { name = "header_field_timestamp_format", default = "%Y-%m-%d %H:%M:%S" },
      { name = "header_field_modified_by", default = 1 },
      { name = "header_alignment", default = 1 },
    },
  },
  {
    title = "Editor behavior",
    fields = {
      { name = "disable_autoformat", default = false },
      { name = "restore_overseer_tasks", default = false },
    },
  },
  {
    title = "Linters",
    fields = {
      {
        name = "linters",
        default = {
          clangtidy = false,
          cppcheck = false,
          cpplint = false,
          dotenv_linter = true,
        },
      },
    },
  },
  {
    title = "LaTeX",
    fields = {
      { name = "vimtex_view_method", default = "zathura" },
    },
  },
  {
    title = "Markdown",
    fields = {
      { name = "bullets_enabled_file_types", default = { "markdown" } },
      { name = "bullets_line_spacing", default = 1 },
      { name = "bullets_pad_right", default = 0 },
      { name = "bullets_checkbox_partials_toggle", default = 1 },
      { name = "bullets_checkbox_markers", default = " .oOX" },
      { name = "bullets_delete_last_bullet_if_empty", default = 1 },
      { name = "bullets_auto_indent_after_colon", default = 1 },
      { name = "bullets_outline_levels", default = { "std-", "std*", "std+" } },
      { name = "vmt_auto_update_on_save", default = 1 },
      { name = "vmt_dont_insert_fence", default = 0 },
      { name = "vmt_cycle_list_item_markers", default = 1 },
      { name = "vmt_list_item_chars", default = { "*", "-", "+" } },
      { name = "table_mode_corner", default = "|" },
    },
  },
}

local fields_by_name

local function get_fields_by_name()
  if fields_by_name then
    return fields_by_name
  end

  fields_by_name = {}
  for _, section in ipairs(sections) do
    for _, field in ipairs(section.fields) do
      fields_by_name[field.name] = field
    end
  end

  return fields_by_name
end

local function copy_value(value)
  if type(value) == "table" then
    return vim.deepcopy(value)
  end

  return value
end

local function format_lua_value(value)
  if type(value) == "string" then
    return string.format("%q", value)
  end

  if type(value) == "table" then
    local items = vim.tbl_map(format_lua_value, value)
    return "{ " .. table.concat(items, ", ") .. " }"
  end

  return tostring(value)
end

local function is_list(value)
  local index = 0

  for key in pairs(value) do
    if type(key) ~= "number" then
      return false
    end
    index = math.max(index, key)
  end

  for item = 1, index do
    if value[item] == nil then
      return false
    end
  end

  return true
end

local function render_field(name, value)
  if type(value) ~= "table" or is_list(value) then
    return { "vim.g." .. name .. " = " .. format_lua_value(value) }
  end

  local lines = { "vim.g." .. name .. " = {" }
  local keys = vim.tbl_keys(value)
  table.sort(keys)

  for _, key in ipairs(keys) do
    table.insert(lines, "  " .. key .. " = " .. format_lua_value(value[key]) .. ",")
  end

  table.insert(lines, "}")
  return lines
end

function M.field(name)
  return get_fields_by_name()[name]
end

function M.sections()
  return sections
end

function M.default(name)
  local field = M.field(name)
  if not field then
    return nil
  end

  return copy_value(field.default)
end

function M.get(name)
  local value = vim.g[name]
  if value ~= nil then
    return value
  end

  return M.default(name)
end

function M.render_template()
  local lines = {
    "-- Project-local Neovim config.",
    "-- This file is loaded by nvim-config-local after you trust it with :ConfigLocalTrust.",
    "-- Fill TODO fields for this repository. Other values below match the repo defaults.",
    "",
  }

  for _, section in ipairs(sections) do
    table.insert(lines, "-- " .. section.title)
    for _, field in ipairs(section.fields) do
      if field.template_lines then
        vim.list_extend(lines, field.template_lines)
      else
        local value = field.template
        if value == nil then
          value = field.default
        end
        vim.list_extend(lines, render_field(field.name, value))
      end
    end
    table.insert(lines, "")
  end

  return table.concat(lines, "\n")
end

return M
