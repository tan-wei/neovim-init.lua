local M = {
  "AckslD/nvim-FeMaco.lua",
  cmd = "FeMaco",
}

M.config = function()
  local mapped_filetype = {
    ["c++"] = "cpp",
    ["cxx"] = "cpp",
  }

  require("femaco").setup {
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
end

return M
