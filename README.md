# neovim-init.lua

Personal Neovim configuration repository.

This repo started from the broader "Neovim from scratch" style of setup, but it has diverged heavily and should now be treated as a standalone personal config rather than a tutorial or general-purpose starter.

## Overview

The configuration is organized around `lazy.nvim` and split into many small plugin specs under `lua/plugins/`. User-specific bootstrapping and behavior live under `lua/user/`.

Highlights of the current setup:

- `lazy.nvim` auto-bootstrap in [lua/user/lazy.lua](lua/user/lazy.lua)
- LSP, completion, treesitter, testing, task, search, terminal, UI, and language-specific modules
- Default completion engine set in [lua/user/config.lua](lua/user/config.lua) (`blink` by default, optional `nvim-cmp`)
- Mason-based LSP/tool management in [lua/plugins/lsp/mason.lua](lua/plugins/lsp/mason.lua)
- Theme-heavy setup with many colorschemes, a randomizer, and theme-aware custom highlight logic
- Frontend-aware behavior for GUI clients and modern terminals
- Extra non-Neovim tool configs under `external/` and file templates under `templates/`

## Distinctive parts

- Theme-first workflow: [lua/plugins/general/colorscheme-randomizer.lua](lua/plugins/general/colorscheme-randomizer.lua) is wired into a large colorscheme collection, and several custom highlight paths derive their colors from the active scheme instead of pinning a fixed palette.
- Semantic token styling is unusually opinionated: [lua/user/lsp/semantic_tokens.lua](lua/user/lsp/semantic_tokens.lua) generates ccls-style `id0..id19` rainbow semantic token groups from existing theme colors, so semantic highlighting stays aligned with the current colorscheme.
- UI rendering changes based on the current frontend or terminal. [lua/util/client.lua](lua/util/client.lua) detects Neovide, Neovim-Qt, Goneovim, Kitty, WezTerm, Ghostty, Alacritty, and others; [lua/plugins/lsp/symbol-usage.lua](lua/plugins/lsp/symbol-usage.lua) switches between bubble, label, and plain-text renderers accordingly.
- The repo tracks surrounding tooling as part of the setup, not as an afterthought: `external/config/` keeps related GUI and terminal configs, and [templates/vim-template](templates/vim-template) stores file templates for common C and C++ entry points.
- Personal workflow keymaps are part of the repo identity, especially quick theme rotation and lightweight selection highlighting in [lua/user/keymaps.lua](lua/user/keymaps.lua).

## Requirements

Use a recent Neovim version. This config uses newer APIs such as `vim.lsp.config`, `vim.lsp.enable`, and modern semantic token handling, so `0.11+` is the practical baseline.

Recommended dependencies:

- `git`
- a Nerd Font
- `ripgrep`
- `fd` or another fast file finder
- language runtimes and external tools you actually use (`python`, `node`, `clangd`, `latex`, etc.)

Some plugins have extra optional requirements. For example, workspace substitution with `nvim-rip-substitute` benefits from `ripgrep` with `pcre2` support.

## Installation

Clone the repo into Neovim's config directory:

```sh
git clone https://github.com/tan-wei/neovim-init.lua.git ~/.config/nvim
```

Start Neovim:

```sh
nvim
```

On first launch, `lazy.nvim` will bootstrap itself and install plugins automatically.

After startup, these commands are usually the first things worth checking:

```vim
:checkhealth
:Mason
```

## Layout

- [init.lua](init.lua): startup entrypoint
- [lua/user](lua/user): user config, options, keymaps, autocommands, LSP setup, semantic token customization
- [lua/plugins](lua/plugins): modular plugin specs grouped by domain
- [lazy-lock.json](lazy-lock.json): pinned plugin versions
- `external/`: related tool configs such as kitty, ghostty, alacritty, wezterm, and goneovim
- `templates/`: file templates
- `spell/`: custom spell additions

## Customization

The lowest-friction entry points are:

- [lua/user/config.lua](lua/user/config.lua): top-level user switches such as completion engine
- [lua/user/keymaps.lua](lua/user/keymaps.lua): personal mappings
- [lua/user/options.lua](lua/user/options.lua): editor defaults
- [lua/user/lsp](lua/user/lsp): LSP handlers, per-server settings, semantic token styling

If you want to remove or swap functionality, the corresponding plugin specs are usually under a matching folder in `lua/plugins/`.

## Project-local config

This repo also supports project-local configuration through `klen/nvim-config-local`.
The current setup looks for these files in the current working directory and
its parent directories:

- `.nvim.lua`
- `.nvimrc`
- `.exrc`
- `.nvim/nvim.lua`

The simplest starting point is `.nvim.lua` in your project root.

Use project-local config when something should only apply to one repository,
such as:

- setting `vim.g.*` globals for Vim plugins
- enabling or disabling repo-specific linters
- adding project-only autocommands, keymaps, or environment tweaks

Typical flow:

1. Create `.nvim.lua` in the project root.
2. Open the project in Neovim.
3. When prompted, inspect the file and allow it.

If the file contents or path change later, Neovim will ask you to trust it
again.

Useful commands:

- `:ConfigLocalEdit` to open or create the local config file
- `:ConfigLocalSource` to source the current project config again
- `:ConfigLocalTrust` to mark the current project config as trusted
- `:ConfigLocalDeny` to deny the current project config

Example: plugin globals for one project only

```lua
vim.g.tex_flavor = "latex"
vim.g.vim_markdown_folding_disabled = 1
```

Example: repo-specific linter toggles

```lua
vim.g.linters = {
	clangtidy = true,
	cppcheck = false,
	cpplint = false,
}
```

This config is read by [lua/plugins/linter/nvim-lint.lua](lua/plugins/linter/nvim-lint.lua).

Example: arbitrary project-local Lua

```lua
vim.env.CC = "clang"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
```

The main tradeoff is flexibility versus discoverability: these files can run
arbitrary Lua or Vimscript, which makes them powerful, but they do not have the
schema validation and completion that more structured project-local config
systems provide.

## Notes

- This is a personal config repo, not a polished distribution.
- The code is a more reliable source of truth than old documentation copied from upstream templates.
- `lazy-lock.json` is committed, so plugin versions are intentionally pinned.
