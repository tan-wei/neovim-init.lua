local status_ok, mkdnflow = pcall(require, "mkdnflow")
if not status_ok then
  return
end

mkdnflow.setup {
  create_dirs = false,
  mappings = {
    MkdnEnter = { { "n", "v" }, "<CR>" },
    MkdnTab = false,
    MkdnSTab = false,
    MkdnNextLink = { "n", "<Tab>" },
    MkdnPrevLink = { "n", "<S-Tab>" },
    MkdnNextHeading = { "n", "]]" },
    MkdnPrevHeading = { "n", "[[" },
    MkdnGoBack = { "n", "<BS>" },
    MkdnGoForward = { "n", "<Del>" },
    MkdnCreateLink = false, -- see MkdnEnter
    MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
    MkdnFollowLink = false, -- see MkdnEnter
    MkdnDestroyLink = false,
    MkdnTagSpan = false,
    MkdnMoveSource = false,
    MkdnYankAnchorLink = { "n", "yaa" },
    MkdnYankFileAnchorLink = { "n", "yfa" },
    MkdnIncreaseHeading = false,
    MkdnDecreaseHeading = false,
    MkdnToggleToDo = false,
    MkdnNewListItem = false,
    MkdnNewListItemBelowInsert = false,
    MkdnNewListItemAboveInsert = false,
    MkdnExtendList = false,
    MkdnUpdateNumbering = false,
    MkdnTableNextCell = false,
    MkdnTablePrevCell = false,
    MkdnTableNextRow = false,
    MkdnTablePrevRow = false,
    MkdnTableNewRowBelow = false,
    MkdnTableNewRowAbove = false,
    MkdnTableNewColAfter = false,
    MkdnTableNewColBefore = false,
    MkdnFoldSection = false,
    MkdnUnfoldSection = false,
  },
}
