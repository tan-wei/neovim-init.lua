local M = {
  "sontungexpt/stcursorword",
  event = "VeryLazy",
}

M.config = function()
  require("stcursorword").setup {
    max_word_length = 100,
    min_word_length = 3,
    excluded = {
      filetypes = {
        "TelescopePrompt",
      },
      buftypes = {
        "nofile",
        "terminal",
      },
      file_patterns = {
        "%.png$",
        "%.jpg$",
        "%.jpeg$",
        "%.pdf$",
        "%.zip$",
        "%.tar$",
        "%.tar%.gz$",
        "%.tar%.xz$",
        "%.tar%.bz2$",
        "%.rar$",
        "%.7z$",
        "%.mp3$",
        "%.mp4$",
      },
    },
    highlight = {
      underline = true,
      fg = nil,
      bg = nil,
    },
  }
end

return M
