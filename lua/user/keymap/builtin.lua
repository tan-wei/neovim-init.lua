local M = {}

local function key(mode, lhs)
  return table.concat({ mode, lhs }, "\0")
end

local OVERRIDES = {
  [key("n", "<C-h>")] = "Move left",
  [key("n", "<C-j>")] = "Move down one line",
  [key("n", "<C-l>")] = "Redraw screen / clear search highlight",
  [key("n", "<C-n>")] = "Move down one line",
  [key("n", "<C-p>")] = "Move up one line",
  [key("n", "<S-h>")] = "H/L line motions",
  [key("n", "<S-l>")] = "H/L line motions",
  [key("n", "<C-w>z")] = "Close preview window",
  [key("n", "<C-w>_")] = "Set current window height to highest possible",
  [key("n", "<C-w>|")] = "Set current window width to widest possible",
  [key("n", "<C-w>=")] = "Make all windows equally high and wide",
  [key("n", "gD")] = "Goto global declaration",
  [key("n", "gd")] = "Goto local declaration",
  [key("n", "gI")] = "Insert text in column 1",
  [key("n", "gr")] = "Virtual replace with {char}",
  [key("v", "<")] = "Indent left",
  [key("v", ">")] = "Indent right",
  [key("v", "p")] = "Visual paste",
  [key("n", "K")] = "Run keywordprg / help for word under cursor",
  [key("x", "J")] = "Join / move in visual block",
  [key("x", "K")] = "Move in visual block",
  [key("n", "y")] = "Yank",
  [key("x", "y")] = "Yank",
  [key("n", "p")] = "Put after cursor",
  [key("n", "P")] = "Put before cursor",
  [key("n", "gp")] = "Put after and leave cursor after text",
  [key("n", "]p")] = "Indent-aware put after",
  [key("n", "[p")] = "Indent-aware put before",
  [key("n", "]P")] = "Indent-aware put after",
  [key("n", "[P")] = "Indent-aware put before",
  [key("n", "ga")] = "Show ASCII value / character info",
  [key("n", "gx")] = "Open filepath/URL/documentLink under cursor",
  [key("x", "gx")] = "Open selected text using system handler",
  [key("n", "<C-a>")] = "Increment number",
  [key("n", "<C-x>")] = "Decrement number",
  [key("n", "g<C-a>")] = "Increment with g-motion semantics",
  [key("n", "g<C-x>")] = "Decrement with g-motion semantics",
  [key("v", "<C-a>")] = "Increment selection",
  [key("v", "<C-x>")] = "Decrement selection",
  [key("n", "-")] = "Move to previous non-blank character",
  [key("n", "zm")] = "Fold more",
  [key("n", "zM")] = "Close all folds",
  [key("n", "zr")] = "Reduce folding",
  [key("n", "zR")] = "Open all folds",
  [key("n", "<tab>")] = "Jump list forward (<C-i>)",
  [key("n", "zC")] = "Close folds recursively",
}

function M.key(mode, lhs)
  return key(mode, lhs)
end

function M.get(mode, lhs)
  return OVERRIDES[key(mode, lhs)]
end

function M.all()
  return vim.deepcopy(OVERRIDES)
end

return M
