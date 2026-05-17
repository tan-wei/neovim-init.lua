local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local events = require "luasnip.util.events"

local function build_header_guard()
  return require("plugins.edit.vim-template").build_header_guard_from_prefix_and_path()
end

local function matching_header_name()
  local stem = vim.fn.expand "%:t:r"
  if stem == "" then
    return "header.hpp"
  end

  return stem .. ".hpp"
end

local function is_source_extension(extension)
  return extension == "cpp" or extension == "cc" or extension == "cxx" or extension == "c++"
end

local function relative_to_current_dir(path)
  local current_dir = vim.fn.expand "%:p:h"
  local relative = path:gsub("^" .. vim.pesc(current_dir) .. "/?", "")
  return relative:gsub("\\", "/")
end

local function collect_local_headers()
  local current_dir = vim.fn.expand "%:p:h"
  local patterns = {
    "**/*.hpp",
    "**/*.h",
    "**/*.hh",
    "**/*.hxx",
  }
  local headers = {}
  local seen = {}

  for _, pattern in ipairs(patterns) do
    for _, path in ipairs(vim.fn.globpath(current_dir, pattern, false, true)) do
      local relative = relative_to_current_dir(path)
      if relative ~= "" and not seen[relative] then
        seen[relative] = true
        table.insert(headers, relative)
      end
    end
  end

  table.sort(headers)

  return headers
end

local function include_choice_node()
  local choices = {}
  local seen = {}

  local function add_text_choice(text)
    if text ~= nil and text ~= "" and not seen[text] then
      seen[text] = true
      table.insert(choices, t(text))
    end
  end

  local extension = vim.fn.expand "%:e"
  local stem = vim.fn.expand "%:t:r"

  if is_source_extension(extension) and stem ~= "" and stem ~= "main" then
    add_text_choice(string.format('#include "%s.hpp"', stem))
    add_text_choice(string.format('#include "%s.h"', stem))
  end

  for _, header in ipairs(collect_local_headers()) do
    add_text_choice(string.format('#include "%s"', header))
  end

  table.insert(choices, sn(nil, fmt('#include "{}"', { i(1, matching_header_name()) })))
  table.insert(choices, sn(nil, fmt("#include <{}>", { i(1, "vector") })))

  for _, system_header in ipairs {
    "algorithm",
    "array",
    "cassert",
    "cstddef",
    "cstdint",
    "functional",
    "iostream",
    "memory",
    "optional",
    "span",
    "string",
    "string_view",
    "unordered_map",
    "utility",
    "vector",
  } do
    add_text_choice(string.format("#include <%s>", system_header))
  end

  return sn(nil, { c(1, choices) })
end

local function repeated_class_name(args)
  local name = args[1][1]
  if name == nil or name == "" then
    return "ClassName"
  end

  return name
end

local function special_members_defaulted()
  return sn(
    nil,
    fmt(
      [[
{}() = default;
~{}() = default;
      ]],
      {
        i(1, "ClassName"),
        f(repeated_class_name, { 1 }),
      }
    )
  )
end

local function special_members_rule_of_three()
  return sn(
    nil,
    fmt(
      [[
{}();
~{}();
{}(const {}& other);
{}& operator=(const {}& other);
      ]],
      {
        i(1, "ClassName"),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
      }
    )
  )
end

local function special_members_rule_of_five()
  return sn(
    nil,
    fmt(
      [[
{}();
~{}();
{}(const {}& other);
{}& operator=(const {}& other);
{}({}&& other) noexcept;
{}& operator=({}&& other) noexcept;
      ]],
      {
        i(1, "ClassName"),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
      }
    )
  )
end

local function special_members_noncopyable()
  return sn(
    nil,
    fmt(
      [[
{}() = default;
~{}() = default;
{}(const {}& other) = delete;
{}& operator=(const {}& other) = delete;
{}({}&& other) = delete;
{}& operator=({}&& other) = delete;
      ]],
      {
        i(1, "ClassName"),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
      }
    )
  )
end

local function add_header_callback()
  return {
    callbacks = {
      [-1] = {
        [events.enter] = function(snip)
          if snip._header_added then
            return
          end

          snip._header_added = true

          vim.schedule(function()
            pcall(vim.cmd, "silent! AddHeader")
          end)
        end,
      },
    },
  }
end

return {
  s(
    {
      trig = "clsd",
      name = "C++ Class Declaration",
      dscr = "Class declaration with default ctor and dtor",
    },
    fmt(
      [[
class {} {{
 public:
  {}() = default;
  ~{}() = default;

  {}

 private:
  {}
}};
      ]],
      {
        i(1, "ClassName"),
        f(repeated_class_name, { 1 }),
        f(repeated_class_name, { 1 }),
        i(2, "// public interface"),
        i(3, "// data members"),
      }
    )
  ),

  s({
    trig = "inc",
    name = "C++ Include",
    dscr = "Choice-based include with companion and local headers",
  }, d(1, include_choice_node, {})),

  s(
    {
      trig = "smf",
      name = "Special Member Functions",
      dscr = "Choice-based Rule of 0/3/5 special member declarations",
    },
    c(1, {
      special_members_defaulted(),
      special_members_rule_of_three(),
      special_members_rule_of_five(),
      special_members_noncopyable(),
    })
  ),

  s(
    {
      trig = "hppf",
      name = "C++ Header File",
      dscr = "Header file with AddHeader and computed guard",
    },
    fmt(
      [[
#pragma once

#ifndef {}
#define {}

{}

#endif /* !{} */
  ]],
      {
        f(build_header_guard),
        f(build_header_guard),
        i(1),
        f(build_header_guard),
      }
    ),
    add_header_callback()
  ),

  s(
    {
      trig = "hguard",
      name = "Header Guard",
      dscr = "Guard block using vim-template guard naming",
    },
    fmt(
      [[
#ifndef {}
#define {}

{}

#endif /* !{} */
  ]],
      {
        f(build_header_guard),
        f(build_header_guard),
        i(1),
        f(build_header_guard),
      }
    )
  ),

  s(
    {
      trig = "cppf",
      name = "C++ Source File",
      dscr = "Source file with matching hpp include",
    },
    fmt(
      [[
#include "{}"

{}
  ]],
      {
        f(matching_header_name),
        i(1),
      }
    )
  ),
}
