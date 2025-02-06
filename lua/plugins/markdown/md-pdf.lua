local M = {
  "arminveres/md-pdf.nvim",
  enabled = require("util.os").is_linux() or require("util.os").is_macos(),
  ft = { "markdown" },
}
local function directory_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

M.config = function()
  if not directory_exists "/usr/share/fonts/pandoc-fonts" then
    vim.defer_fn(function()
      vim.notify("/usr/share/fonts/pandoc-fonts does not exist, md-pdf.nvim is not useable", vim.log.levels.WARN)
    end, 1000)
    return
  end

  local templates_location = vim.fn.stdpath "config" .. "/Pandoc-Themes/"
  local template = templates_location .. "purple-plain.tex"

  require("md-pdf").setup {
    preview_cmd = function()
      return "firefox"
    end,
    fonts = nil,
    pandoc_user_args = {
      "--template=" .. template,
    },
    output_path = ".",
    pdf_engine = "xelatex",
  }
end

return M
