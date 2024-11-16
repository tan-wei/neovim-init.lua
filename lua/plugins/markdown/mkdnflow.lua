local M = {
  "jakewvincent/mkdnflow.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = "markdown",
}

-- TODO: This plugin should write more configurations
M.opts = {
  mappings = {
    MkdnEnter = false,
    MkdnTab = false,
    MkdnSTab = false,
    MkdnNextLink = false,
    MkdnPrevLink = false,
    MkdnNextHeading = false,
    MkdnPrevHeading = false,
    MkdnGoBack = false,
    MkdnGoForward = false,
    MkdnCreateLink = false,
    MkdnCreateLinkFromClipboard = false,
    MkdnFollowLink = false,
    MkdnDestroyLink = false,
    MkdnTagSpan = false,
    MkdnMoveSource = false,
    MkdnYankAnchorLink = false,
    MkdnYankFileAnchorLink = false,
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

return M
