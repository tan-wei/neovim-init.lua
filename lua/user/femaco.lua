local status_ok, femaco = pcall(require, "femaco")
if not status_ok then
  return
end

local mapped_filetype = {
  ["c++"] = "cpp",
  ["cxx"] = "cpp",
}

femaco.setup {
  ft_from_lang = function(lang)
    if mapped_filetype[lang] then
      return mapped_filetype[lang]
    end
    return lang
  end,

  ensure_newline = function(base_filetype)
    return true
  end,
}
