local M = {}

local rainbow_token_types = {
  "namespace",
  "type",
  "class",
  "enum",
  "interface",
  "struct",
  "typeParameter",
  "parameter",
  "variable",
  "property",
  "enumMember",
  "event",
  "function",
  "method",
  "macro",
  "modifier",
  "operator",
  "decorator",
  "label",
  "typeAlias",
  "constructor",
  "concept",
  "unknown",
}

local token_family_hue_offsets = {}
local token_family_lightness_offsets = {}

for index, token_type in ipairs(rainbow_token_types) do
  token_family_hue_offsets[token_type] = (((index - 1) % 7) - 3) * 0.008
  token_family_lightness_offsets[token_type] = (((index - 1) % 5) - 2) * 0.012
end

local rainbow_token_sources = {
  ["namespace"] = { "@lsp.type.namespace", "@module", "@namespace", "Include", "Identifier", "Normal" },
  ["type"] = { "@lsp.type.type", "@type", "Type", "Identifier", "Normal" },
  ["class"] = { "@lsp.type.class", "@type", "Type", "Identifier", "Normal" },
  ["enum"] = { "@lsp.type.enum", "@type", "Type", "Identifier", "Normal" },
  ["interface"] = { "@lsp.type.interface", "@type", "Type", "Identifier", "Normal" },
  ["struct"] = { "@lsp.type.struct", "@type", "Type", "Identifier", "Normal" },
  ["typeParameter"] = { "@lsp.type.typeParameter", "@type.parameter", "@type", "Type", "Identifier", "Normal" },
  ["parameter"] = { "@lsp.type.parameter", "@variable.parameter", "@parameter", "Identifier", "Normal" },
  ["variable"] = { "@lsp.type.variable", "@variable", "Identifier", "Normal" },
  ["property"] = { "@lsp.type.property", "@property", "@field", "Identifier", "Normal" },
  ["enumMember"] = { "@lsp.type.enumMember", "@constant", "Constant", "Identifier", "Normal" },
  ["event"] = { "@lsp.type.event", "@constant", "Constant", "Identifier", "Normal" },
  ["function"] = { "@lsp.type.function", "@function", "Function", "Identifier", "Normal" },
  ["method"] = { "@lsp.type.method", "@function.method", "@method", "Function", "Identifier", "Normal" },
  ["macro"] = { "@lsp.type.macro", "@function.macro", "Macro", "PreProc", "Identifier", "Normal" },
  ["modifier"] = { "@lsp.type.modifier", "@keyword.modifier", "@keyword", "Keyword", "Statement", "Normal" },
  ["operator"] = { "@lsp.type.operator", "@operator", "Operator", "Statement", "Normal" },
  ["decorator"] = { "@lsp.type.decorator", "@attribute", "PreProc", "Special", "Identifier", "Normal" },
  ["label"] = { "@lsp.type.label", "@label", "Label", "Special", "Identifier", "Normal" },
  ["typeAlias"] = { "@lsp.type.type", "@type.definition", "@type", "Type", "Identifier", "Normal" },
  ["constructor"] = { "@constructor", "@lsp.type.function", "Function", "Identifier", "Normal" },
  ["concept"] = { "@lsp.type.type", "@type", "Type", "Identifier", "Normal" },
  ["unknown"] = { "Identifier", "Normal" },
}

local generic_rainbow_sources = { "@lsp.type.variable", "@variable", "Identifier", "Normal" }

local hue_offsets = {
  0.000,
  0.016,
  -0.016,
  0.032,
  -0.032,
  0.048,
  -0.048,
  0.064,
  -0.064,
  0.080,
  -0.080,
  0.096,
  -0.096,
  0.112,
  -0.112,
  0.128,
  -0.128,
  0.144,
  -0.144,
  0.160,
}

local saturation_offsets = {
  0.08,
  -0.03,
  0.10,
  -0.05,
  0.06,
  -0.02,
  0.12,
  -0.07,
  0.04,
  -0.04,
  0.09,
  -0.06,
  0.05,
  -0.01,
  0.11,
  -0.08,
  0.03,
  -0.03,
  0.07,
  -0.05,
}

local lightness_offsets = {
  0.06,
  -0.05,
  0.10,
  -0.08,
  0.04,
  -0.03,
  0.12,
  -0.10,
  0.05,
  -0.06,
  0.08,
  -0.07,
  0.03,
  -0.02,
  0.11,
  -0.09,
  0.07,
  -0.04,
  0.09,
  -0.08,
}

local function h(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if not ok or vim.tbl_isempty(hl) then
    return {}
  end
  return hl
end

local function hl_value(names, key)
  for _, name in ipairs(names) do
    local value = h(name)[key]
    if value ~= nil then
      return value
    end
  end
end

local function clamp(value, minimum, maximum)
  return math.min(math.max(value, minimum), maximum)
end

local function int_to_rgb(color)
  local red = math.floor(color / 0x10000) / 255
  local green = math.floor(color / 0x100) % 0x100 / 255
  local blue = color % 0x100 / 255

  return red, green, blue
end

local function rgb_to_int(red, green, blue)
  return math.floor(clamp(red, 0, 1) * 255 + 0.5) * 0x10000
    + math.floor(clamp(green, 0, 1) * 255 + 0.5) * 0x100
    + math.floor(clamp(blue, 0, 1) * 255 + 0.5)
end

local function rgb_to_hsl(red, green, blue)
  local max_channel = math.max(red, green, blue)
  local min_channel = math.min(red, green, blue)
  local hue
  local saturation
  local lightness = (max_channel + min_channel) / 2

  if max_channel == min_channel then
    hue = 0
    saturation = 0
  else
    local delta = max_channel - min_channel
    saturation = lightness > 0.5 and delta / (2 - max_channel - min_channel) or delta / (max_channel + min_channel)

    if max_channel == red then
      hue = (green - blue) / delta + (green < blue and 6 or 0)
    elseif max_channel == green then
      hue = (blue - red) / delta + 2
    else
      hue = (red - green) / delta + 4
    end

    hue = hue / 6
  end

  return hue, saturation, lightness
end

local function hue_to_rgb(lower, upper, position)
  if position < 0 then
    position = position + 1
  end
  if position > 1 then
    position = position - 1
  end
  if position < 1 / 6 then
    return lower + (upper - lower) * 6 * position
  end
  if position < 1 / 2 then
    return upper
  end
  if position < 2 / 3 then
    return lower + (upper - lower) * (2 / 3 - position) * 6
  end
  return lower
end

local function hsl_to_rgb(hue, saturation, lightness)
  if saturation == 0 then
    return lightness, lightness, lightness
  end

  local upper = lightness < 0.5 and lightness * (1 + saturation) or lightness + saturation - lightness * saturation
  local lower = 2 * lightness - upper

  return hue_to_rgb(lower, upper, hue + 1 / 3), hue_to_rgb(lower, upper, hue), hue_to_rgb(lower, upper, hue - 1 / 3)
end

local function is_dark_background(background)
  if background == nil then
    return true
  end

  local red, green, blue = int_to_rgb(background)
  local luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue

  return luminance < 0.5
end

local function derived_color(base_color, background, id, token_type)
  if base_color == nil then
    return nil
  end

  local hue, saturation, lightness = rgb_to_hsl(int_to_rgb(base_color))
  local index = id + 1
  local lightness_direction = is_dark_background(background) and 1 or -1
  local family_hue_offset = token_type and token_family_hue_offsets[token_type] or 0
  local family_lightness_offset = token_type and token_family_lightness_offsets[token_type] or 0

  hue = (hue + family_hue_offset + hue_offsets[index]) % 1
  saturation = clamp(saturation + saturation_offsets[index], 0.20, 0.95)
  lightness = clamp(lightness + family_lightness_offset + lightness_offsets[index] * lightness_direction, 0.18, 0.82)

  local red, green, blue = hsl_to_rgb(hue, saturation, lightness)
  return rgb_to_int(red, green, blue)
end

local function token_base_color(token_type)
  return hl_value(rainbow_token_sources[token_type] or generic_rainbow_sources, "fg")
end

local function set_fg(group, fg)
  if fg == nil then
    vim.api.nvim_set_hl(0, group, {})
    return
  end

  vim.api.nvim_set_hl(0, group, { fg = fg })
end

local function apply_rainbow_semantic_highlights()
  local background = hl_value({ "Normal", "NormalFloat", "CursorLine" }, "bg")
  local generic_base = hl_value(generic_rainbow_sources, "fg")
  local token_base_colors = {}

  for _, token_type in ipairs(rainbow_token_types) do
    token_base_colors[token_type] = token_base_color(token_type)
  end

  for id = 0, 19 do
    local fg = derived_color(generic_base, background, id)
    local modifier_group = ("@lsp.mod.id%d"):format(id)
    set_fg(modifier_group, fg)

    for _, token_type in ipairs(rainbow_token_types) do
      local type_fg = derived_color(token_base_colors[token_type], background, id, token_type)
      local typemod_group = ("@lsp.typemod.%s.id%d"):format(token_type, id)
      set_fg(typemod_group, type_fg or fg)
    end
  end

  vim.api.nvim_set_hl(0, "@lsp.mod.classScope", { italic = true })
  vim.api.nvim_set_hl(0, "@lsp.mod.namespaceScope", { bold = true, underline = true })
end

function M.setup()
  apply_rainbow_semantic_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("SemanticTokenRainbowHighlights", { clear = true }),
    callback = apply_rainbow_semantic_highlights,
  })
end

return M
