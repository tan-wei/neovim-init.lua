---@type LazyPluginSpec
local M = {
  "chrisgrieser/nvim-various-textobjs",
  event = "VeryLazy",
}

M.keys = {
  {
    "ii",
    '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>',
    mode = { "o", "x" },
    desc = "inner indentation",
  },
  {
    "ai",
    '<cmd>lua require("various-textobjs").indentation("outer", "inner")<CR>',
    mode = { "o", "x" },
    desc = "outer indentation",
  },
  {
    "aI",
    '<cmd>lua require("various-textobjs").indentation("outer", "outer")<CR>',
    mode = { "o", "x" },
    desc = "outer indentation (expanded)",
  },
  {
    "iI",
    '<cmd>lua require("various-textobjs").indentation("inner", "outer")<CR>',
    mode = { "o", "x" },
    desc = "inner indentation (with outer border)",
  },
  {
    "R",
    '<cmd>lua require("various-textobjs").restOfIndentation()<CR>',
    mode = { "o", "x" },
    desc = "rest of indentation",
  },
  {
    "ag",
    '<cmd>lua require("various-textobjs").greedyOuterIndentation("outer")<CR>',
    mode = { "o", "x" },
    desc = "greedy outer indentation",
  },
  {
    "ig",
    '<cmd>lua require("various-textobjs").greedyOuterIndentation("inner")<CR>',
    mode = { "o", "x" },
    desc = "greedy inner indentation",
  },
  { "iS", '<cmd>lua require("various-textobjs").subword("inner")<CR>', mode = { "o", "x" }, desc = "inner subword" },
  { "aS", '<cmd>lua require("various-textobjs").subword("outer")<CR>', mode = { "o", "x" }, desc = "outer subword" },
  {
    "C",
    '<cmd>lua require("various-textobjs").toNextClosingBracket()<CR>',
    mode = { "o", "x" },
    desc = "to next closing bracket",
  },
  { "io", '<cmd>lua require("various-textobjs").anyBracket("inner")<CR>', mode = { "o", "x" }, desc = "inner bracket" },
  { "ao", '<cmd>lua require("various-textobjs").anyBracket("outer")<CR>', mode = { "o", "x" }, desc = "outer bracket" },
  { "iq", '<cmd>lua require("various-textobjs").anyQuote("inner")<CR>', mode = { "o", "x" }, desc = "inner quote" },
  { "aq", '<cmd>lua require("various-textobjs").anyQuote("outer")<CR>', mode = { "o", "x" }, desc = "outer quote" },
  {
    "Q",
    '<cmd>lua require("various-textobjs").toNextQuotationMark()<CR>',
    mode = { "o", "x" },
    desc = "to next quotation mark",
  },
  {
    "r",
    '<cmd>lua require("various-textobjs").restOfParagraph()<CR>',
    mode = { "o", "x" },
    desc = "rest of paragraph",
  },
  { "gG", '<cmd>lua require("various-textobjs").entireBuffer()<CR>', mode = { "o", "x" }, desc = "entire buffer" },
  -- { "n", '<cmd>lua require("various-textobjs").nearEoL()<CR>', mode = { "o", "x" }, desc = "near end of line" }, -- FIXME: Cause duplicate keymap
  {
    "i_",
    '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<CR>',
    mode = { "o", "x" },
    desc = "inner line characterwise",
  },
  {
    "a_",
    '<cmd>lua require("various-textobjs").lineCharacterwise("outer")<CR>',
    mode = { "o", "x" },
    desc = "outer line characterwise",
  },
  { "|", '<cmd>lua require("various-textobjs").column("down")<CR>', mode = { "o", "x" }, desc = "column down" },
  {
    "a|",
    '<cmd>lua require("various-textobjs").column("both")<CR>',
    mode = { "o", "x" },
    desc = "column both directions",
  },
  { "iv", '<cmd>lua require("various-textobjs").value("inner")<CR>', mode = { "o", "x" }, desc = "inner value" },
  { "av", '<cmd>lua require("various-textobjs").value("outer")<CR>', mode = { "o", "x" }, desc = "outer value" },
  { "ik", '<cmd>lua require("various-textobjs").key("inner")<CR>', mode = { "o", "x" }, desc = "inner key" },
  { "ak", '<cmd>lua require("various-textobjs").key("outer")<CR>', mode = { "o", "x" }, desc = "outer key" },
  { "L", '<cmd>lua require("various-textobjs").url()<CR>', mode = { "o", "x" }, desc = "url" },
  { "in", '<cmd>lua require("various-textobjs").number("inner")<CR>', mode = { "o", "x" }, desc = "inner number" },
  { "an", '<cmd>lua require("various-textobjs").number("outer")<CR>', mode = { "o", "x" }, desc = "outer number" },
  { "!", '<cmd>lua require("various-textobjs").diagnostic()<CR>', mode = { "o", "x" }, desc = "diagnostic" },
  {
    "iz",
    '<cmd>lua require("various-textobjs").closedFold("inner")<CR>',
    mode = { "o", "x" },
    desc = "inner closed fold",
  },
  {
    "az",
    '<cmd>lua require("various-textobjs").closedFold("outer")<CR>',
    mode = { "o", "x" },
    desc = "outer closed fold",
  },
  {
    "im",
    '<cmd>lua require("various-textobjs").chainMember("inner")<CR>',
    mode = { "o", "x" },
    desc = "inner chain member",
  },
  {
    "am",
    '<cmd>lua require("various-textobjs").chainMember("outer")<CR>',
    mode = { "o", "x" },
    desc = "outer chain member",
  },
  {
    "gw",
    '<cmd>lua require("various-textobjs").visibleInWindow()<CR>',
    mode = { "o", "x" },
    desc = "visible in window",
  },
  { "gW", '<cmd>lua require("various-textobjs").restOfWindow()<CR>', mode = { "o", "x" }, desc = "rest of window" },
  { "g;", '<cmd>lua require("various-textobjs").lastChange()<CR>', mode = { "o", "x" }, desc = "last change" },
  {
    "iN",
    '<cmd>lua require("various-textobjs").notebookCell("inner")<CR>',
    mode = { "o", "x" },
    desc = "inner notebook cell",
  },
  {
    "aN",
    '<cmd>lua require("various-textobjs").notebookCell("outer")<CR>',
    mode = { "o", "x" },
    desc = "outer notebook cell",
  },
  { ".", '<cmd>lua require("various-textobjs").emoji()<CR>', mode = { "o", "x" }, desc = "emoji" },
  { "i,", '<cmd>lua require("various-textobjs").argument("inner")<CR>', mode = { "o", "x" }, desc = "inner argument" },
  { "a,", '<cmd>lua require("various-textobjs").argument("outer")<CR>', mode = { "o", "x" }, desc = "outer argument" },
  { "iF", '<cmd>lua require("various-textobjs").filepath("inner")<CR>', mode = { "o", "x" }, desc = "inner filepath" },
  { "aF", '<cmd>lua require("various-textobjs").filepath("outer")<CR>', mode = { "o", "x" }, desc = "outer filepath" },
  { "i#", '<cmd>lua require("various-textobjs").color("inner")<CR>', mode = { "o", "x" }, desc = "inner color" },
  { "a#", '<cmd>lua require("various-textobjs").color("outer")<CR>', mode = { "o", "x" }, desc = "outer color" },
  {
    "iD",
    '<cmd>lua require("various-textobjs").doubleSquareBrackets("inner")<CR>',
    mode = { "o", "x" },
    desc = "inner double square brackets",
  },
  {
    "aD",
    '<cmd>lua require("various-textobjs").doubleSquareBrackets("outer")<CR>',
    mode = { "o", "x" },
    desc = "outer double square brackets",
  },
}

M.config = function()
  require("various-textobjs").setup {
    forwardLooking = {
      small = 5,
      big = 15,
    },
  }
end

return M
