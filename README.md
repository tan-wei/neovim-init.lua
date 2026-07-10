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

Use a recent Neovim version. This config uses newer APIs such as `vim.lsp.config`, `vim.lsp.enable`, and modern semantic token handling, and it currently tracks `nvim-treesitter`'s `main` branch, so `0.12+` / nightly is the practical baseline.

Recommended dependencies:

- `git`
- `curl`
- `tar`
- a Nerd Font
- `ripgrep`
- `fd` or another fast file finder
- `tree-sitter-cli` installed via your system package manager, not `npm`. This repo uses `nvim-treesitter`'s `main` branch, and parser install/update expects the CLI to be available.
- native build tools for plugins and parsers:
	- Unix: a C/C++ compiler (`gcc` or `clang`), `make`, and `cmake`
	- Windows: MSVC Build Tools or `clang-cl`, plus `cmake`
- `node` 22+ if you keep `copilot.lua` enabled. The plugin requires Node.js and `curl`; this repo does not call `npm` directly.
- `ruby` if you keep Mason automatic installation enabled, because the default Mason LSP list includes `solargraph`
- language runtimes and external tools you actually use (`python`, `clangd`, `latex`, etc.)

Depending on platform and feature usage, a Rust toolchain (`cargo`/`rustc`) may also be useful for Rust-specific workflows or plugins that need a local Rust build.

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

Before first launch, make sure the bootstrap dependencies above are installed. This config will bootstrap `lazy.nvim`, build native plugins, update Treesitter parsers, and let Mason install its default toolchain on startup.

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

## Keymap inventory

This section is the repo-level source of truth for repo-owned keymaps.

Maintenance contract:

1. Any change that adds, removes, or repurposes a keymap in [lua/user/keymap/plain.lua](lua/user/keymap/plain.lua), [lua/user/keymap/lazy.lua](lua/user/keymap/lazy.lua), [lua/user/keymap/buffer.lua](lua/user/keymap/buffer.lua), [lua/user/keymap/which_key.lua](lua/user/keymap/which_key.lua), [lua/user/autocommands.lua](lua/user/autocommands.lua), or plugin specs with `M.keys` must update this section in the same change.
2. If a key replaces a core Neovim mapping, keep the `Overrides builtin` and `Replaced meaning` columns in sync. For builtin-like normal-mode slots (`g*`, `z*`, `<C-w>*`, single-key, `Ctrl-letter`), add `conflict.builtin` or at least `conflict.note` in the registry entry so the audit knows the slot was reviewed.
3. Centralized `[` / `]` entries must declare whether they are bracket `motion` or bracket `action` via `symbol = { ... }`. Bracket motions are expected to be previous/next pairs and repeat through demicolon; bracket actions must opt out with `symbol.repeatable = false`.
4. Centralized `>` / `<` / `=` entries are treated as operator-style actions, not navigation prefixes. They must declare `symbol = { family = "operator", role = "action", repeatable = false, ... }`.
5. `(` / `)` / `{` / `}` stay reserved for native motions rather than repo-defined prefix families.
6. Buffer-local mappings should be documented with their scope, not only by key.

Scope notes:

- This inventory focuses on repo-owned mappings and repo-generated prefixes.
- It does not fully expand upstream default plugin mappings inherited from plugins, such as `nvim-tree`'s `default_on_attach()` defaults.
- `mapleader` and `maplocalleader` are both `\`, configured in [lua/user/config.lua](lua/user/config.lua).
- Plugin-local bracket families that are still generated outside the centralized registry, such as toggle.nvim's `[o` / `]o`, are documented here but are not yet covered by the symbol-family audit.

### Symbol families

- `[` / `]` are the repo's navigation family. Use them for previous/next style motions like `[b` / `]b`; centralized motion entries should be repeatable with demicolon.
- `[` / `]` may still host actions when Neovim or a plugin already uses that syntax, such as Yanky's `[p` / `]p`, but those entries should explicitly opt out of repeatability.
- `>` / `<` / `=` are operator-style action families. Keep them for transforms such as Yanky's shifted or filtered puts, not for next/previous navigation.
- `(` / `)` / `{` / `}` are kept for native motions rather than repo-owned prefix namespaces.

### Ctrl / Alt / Function / Special keys

| Mode | Key | Current meaning | Overrides builtin | Replaced meaning / notes |
| --- | --- | --- | --- | --- |
| `n` | `<C-Up>`, `<C-Down>`, `<C-Left>`, `<C-Right>` | Resize splits | No | Repo-owned resize shortcuts |
| `n` | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Treewalker structural navigation | No | Uses nonstandard control slots for syntax-aware movement |
| `all` | `<C-\\>` | Toggle floating terminal | No | Set by toggleterm `open_mapping` |
| `n` | `<C-w>z`, `<C-w>_`, `<C-w>\|`, `<C-w>=` | windows.nvim maximize / equalize helpers | Yes | Replaces core window commands with plugin implementations |
| `n`, `v` | `<C-a>`, `<C-x>` | dial.nvim increment / decrement | Yes | Replaces core numeric increment / decrement with dial logic |
| `n` | `<C-n>`, `<C-p>` | Yank history next / previous | Yes | Replaces normal-mode slots with Yanky ring navigation |
| `i`, `s` | `<C-n>`, `<C-p>` | LuaSnip next / previous choice | Yes | Replaces insert/select completion-style navigation |
| `n`, `v`, `x` | `<A-j>`, `<A-k>` | Move line / block up or down | No | Repo-owned move.nvim mappings |
| `n`, `v` | `<A-h>`, `<A-l>` | Move character / block left or right | No | Repo-owned move.nvim mappings |
| `n`, `o`, `x` | `<A-w>`, `<A-e>`, `<A-b>` | Spider subword motions | No | Repo-owned alternative word motions |
| `n`, `x` | `<A-q>` | Toggle multicursor | No | Repo-owned multicursor entrypoint |
| `i` | `<A-e>` | nvim-autopairs fast-wrap | No | Repo-owned insert helper |
| `n`, `x` | `<Up>`, `<Down>` | Add cursor above / below | Yes | Replaces plain cursor movement with multicursor actions |
| `n` | `<C-LeftMouse>`, `<C-LeftDrag>`, `<C-LeftRelease>` | Multicursor mouse interactions | Yes | Replaces core mouse selection behavior |
| `n` | `<S-h>`, `<S-l>` | Previous / next buffer | Yes | Replaces `H` / `L` screen-line motions |
| `n` | `<F1>` | Toggle profiling | No | Repo-owned profile.nvim helper |
| `n` | `<F2>` | Live rename | No | Repo-owned rename helper |
| `v` | `<F3>`, `<F4>` | Add / remove highlight | No | Repo-owned highlighting helpers |
| `n` | `<F5>` | `OverseerRun` | No | Repo-owned task runner shortcut |
| `n` | `<F6>` | DAP continue | No | Repo-owned debug helper |
| `n` | `<F8>` | Randomize colorscheme | No | Repo-owned theme rotation shortcut |
| `n` | `<F9>`, `<F10>`, `<F11>` | DAP breakpoint / step over / step into | No | Repo-owned debug helpers |
| `n` | `<F17>`, `<F23>` | DAP terminate / step out | No | Repo-owned debug helpers |

### `g*` keys

| Mode | Key | Current meaning | Overrides builtin | Replaced meaning / notes |
| --- | --- | --- | --- | --- |
| `n` | `gD` | LSP declaration | Yes | Replaces core declaration jump with LSP declaration |
| `n` | `gd` | LSP definition | Yes | Replaces core local-definition jump with LSP definition |
| `n` | `gI` | LSP implementation | No | Repo-owned LSP slot |
| `n` | `gr` | LSP references | No | Repo-owned LSP slot |
| `n` | `gl` | Diagnostic float | No | Repo-owned diagnostics slot |
| `n`, `x` | `ga` | EasyAlign | Yes | Replaces core character info display |
| `n`, `x` | `gx` | `Browse` open under cursor | Yes | Replaces builtin open-under-cursor behavior with gx.nvim's `:Browse` |
| `n`, `v` | `g<C-a>`, `g<C-x>` | dial.nvim gnormal / gvisual increment / decrement | Yes | Replaces core `g<C-a>` / `g<C-x>` numeric operations |
| `n`, `x` | `gcr` | coerce motion / visual transform entrypoint | No | Repo-owned transform slot |

### `z*` and fold-related keys

| Mode | Key | Current meaning | Overrides builtin | Replaced meaning / notes |
| --- | --- | --- | --- | --- |
| `n` | `zR`, `zM`, `zr`, `zm` | ufo fold open / close helpers | Yes | Replaces core fold controls with ufo implementations |
| `n` | `zC` | fold-cycle `close_all()` | Yes | Replaces core recursive fold close |
| `n` | `K` | Peek folded lines, else hover | Yes | Replaces core `keywordprg` / help behavior; also shadowed by LSP buffer-local `K` |
| `n` | `<Tab>`, `<S-Tab>` | fold-cycle open / close | Yes for `<Tab>` | `<Tab>` replaces jump-list forward (`<C-i>` equivalent); `<S-Tab>` is a repo-owned slot |

### `[` / `]` / operator families

| Mode | Key | Current meaning | Overrides builtin | Replaced meaning / notes |
| --- | --- | --- | --- | --- |
| `n` | `[b`, `]b` | Previous / next buffer | No | Bracket motion family; repeatable with demicolon |
| `n`, `x` | `[e`, `]e` | Previous / next delimiter | No | sort.nvim bracket motion family; repeatable with demicolon |
| `n` | `[S`, `]S` | Previous / next scrollview mark | No | Bracket motion family; repeatable with demicolon |
| `n` | `[g`, `]g` | Previous / next git hunk | No | Bracket motion family; repeatable with demicolon |
| `n` | `[r`, `]r` | Previous / next reference | No | Refjump motion family; repeatable with demicolon |
| `n` | `[p`, `]p`, `[P`, `]P` | Yanky indent-aware put | Yes | Bracket action family; intentionally non-repeatable |
| `n` | `>p`, `<p`, `>P`, `<P`, `=p`, `=P` | Yanky shift / filter put helpers | Yes | Operator-style action family; intentionally non-repeatable |
| `n`, `x` | `[m`, `]m`, `[M`, `]M` | Multicursor match add / skip | No | Repo-owned multicursor navigation |
| `n` | `[t`, `]t`, `[T`, `]T` | Previous / next test, previous / next failed test | No | Repo-owned neotest motions; custom demicolon repeat wrapper |
| `n` | `[o{option}`, `]o{option}` | toggle.nvim previous / next option state | No | Plugin-generated toggle prefix family |

### Bare keys and text-object families

| Mode | Key | Current meaning | Overrides builtin | Replaced meaning / notes |
| --- | --- | --- | --- | --- |
| `n`, `x` | `y` | Yanky yank | Yes | Replaces core yank with yank-ring aware yank |
| `n` | `p`, `P`, `gp` | Yanky put family | Yes | Replaces core put family with yank-ring aware put |
| `n` | `n`, `N` | hlslens-enhanced next / previous match | Yes | Replaces builtin `n` / `N` with hlslens overlay |
| `n` | `*`, `#` | hlslens-enhanced next / previous word match | Yes | Replaces builtin `*` / `#` with hlslens overlay |
| `n` | `g*`, `g#` | hlslens-enhanced next / previous partial-word match | Yes | Replaces builtin `g*` / `g#` with hlslens overlay |
| `n` | `cr` | coerce current word | No | Repo-owned transform entrypoint |
| `i` | `jk`, `kj` | Exit insert mode | No | Repo-owned insert escape shortcuts |
| `v` | `<`, `>` | Reindent and keep selection | Yes | Extends core indent behavior to preserve selection |
| `v` | `p` | Black-hole delete then paste | Yes | Avoids clobbering unnamed register |
| `x` | `J`, `K` | Move selected block down / up | Yes | Replaces core visual/block behavior |
| `n` | `-` | Open Oil float | Yes | Replaces core first-nonblank line motion |
| `n` | `q` in `qf`, `help`, `man`, `lspinfo` buffers | Close auxiliary window | Yes | Buffer-local override of macro recording key |
| `n` | `yo{option}`, `yos` | toggle.nvim toggle option / dashboard | No | Plugin-generated option prefix family |
| `o`, `x` | various-textobjs family | Extra text objects for indentation, subword, brackets, quotes, values, keys, numbers, diagnostics, folds, chain members, notebook cells, filepaths, colors, and more | Mixed | Exact leaf list lives in [lua/plugins/edit/nvim-various-textobjs.lua](lua/plugins/edit/nvim-various-textobjs.lua) |

### `<leader>` families

`<leader>` is `\\`. The table below lists repo-owned namespaces and leaf keys.

| Prefix | Leaf keys | Current meaning | Overrides builtin | Notes |
| --- | --- | --- | --- | --- |
| `<leader>A` | `A` | Alpha dashboard | No | Standalone action |
| `<leader>a` | `a` | `NodeAction` | No | Standalone action |
| `<leader>b` | `bb`, `bn`, `bi`, `bI`, `bc`, `bp`, `bP`, `bf`, `bh`, `bl`, `bm`, `bM`, `bsd`, `bsl`, `bst`, `bsr` | Buffer navigation, close, pick, menu, sort, indent-blankline toggle | No | Buffer namespace |
| `<leader>C` | `Cs`, `Ci`, `CI`, `Ca`, `CS`, `Ct`, `Cm`, `CD`, `Cf`, `Cc`, `C3`, `C5` | clangd / C++ helper actions | No | C++ namespace |
| `<leader>c` | `c` | Close current buffer | No | Standalone action |
| `<leader>d` | `d` | Dropbar pick | No | Plain `d` is a standalone action, but `d*` also hosts DAP keys |
| `<leader>d*` | `dp`, `dP`, `dR`, `dl` | DAP condition breakpoint, log point, REPL, run last | No | Debug namespace piggybacks on `<leader>d` |
| `<leader>e` | `e` | Toggle NvimTree | No | Standalone action |
| `<leader>F` | `F` | Live grep with args | No | Standalone action |
| `<leader>f` | `f` | Find files | No | Standalone action |
| `<leader>g` | `gB`, `gb`, `gc`, `gd`, `gl`, `gj`, `gk`, `gp`, `gr`, `gR`, `gs`, `gu`, `go` | Git blame, branches, commits, diff, LazyGit, hunk operations, status | No | Git namespace |
| `<leader>h` | `h` | Clear search highlight | No | Standalone action |
| `<leader>H` | `H` | Clear search highlight and export last search to quickfix | No | Standalone action |
| `<leader>j` | `jj`, `jk`, `jcj`, `jck`, `jgj`, `jgk`, `jhj`, `jhk`, `jqj`, `jqk` | Portal jumplist / changelist / grapple / harpoon / quickfix jumps | No | Jump namespace |
| `<leader>L` | `Ld`, `Lr` | Linediff and reset | No | Line-diff namespace |
| `<leader>l` | `la`, `ld`, `lD`, `lf`, `lF`, `lh`, `li`, `lI`, `lj`, `lk`, `ll`, `lo`, `lq`, `lr`, `ls`, `lS` | LSP code actions, diagnostics, symbols, format, hover, rename, signature, outline | No | LSP namespace |
| `<leader>M` | `Mg`, `Mj`, `Ms`, `Mt` | Grapple mark / select / scopes / tags | No | Marks namespace |
| `<leader>m` | `ma`, `mm`, `mn`, `mp`, `m1`, `m2`, `m3`, `m4` | Harpoon toggle, menu, prev/next, select slot | No | Harpoon namespace |
| `<leader>o` | `o` | Smart open | No | Standalone action |
| `<leader>P` | `P` | Projects picker | No | Standalone action |
| `<leader>p` | `pd`, `pc`, `pu`, `pU`, `pf`, `ps`, `pv`, `pt`, `po` | Overlook peek / close / restore / focus / split / vsplit / tab / current window | No | Popup namespace |
| `<leader>q` | `qq`, `qp`, `qs`, `qe`, `qy`, `qd` | Macro start/stop, play, switch slot, edit, yank, delete | No | Macro namespace |
| `<leader>R` | `Rr`, `Rs`, `RS`, `Rf`, `Rh`, `Rc`, `Rl` | REPL run / restart / sniprun / focus / hide / send file / send until cursor | No | REPL namespace |
| `<leader>r` | `rc`, `rf`, `rs` | RunCode / RunFile / stop runner | No | Run namespace |
| `<leader>s` | `ss`, `sS`, `sy`, `sg`, `sf`, `si`, `sa`, `sb`, `sc`, `sC`, `sh`, `sk`, `sM`, `so`, `sp`, `sr`, `sR` | Flash, grug-far, yank history, AST grep, buffer search, colorschemes, commands, help, keymaps, man, smart open, pickers, recent files, registers | No | Search namespace |
| `<leader>T` | `Tf`, `Th`, `Tv` | Float / horizontal / vertical terminal | No | Terminal namespace |
| `<leader>t` | `tm`, `tg`, `tr`, `tu`, `tn`, `tl`, `tc`, `ts`, `to`, `tp`, `tw`, `tj`, `tk` | Table mode, TOC, neotest run / output / panel / watch / failed-test jumps | No | Test/table namespace; `tj` / `tk` currently look typo-prone in config |
| `<leader>w` | `wl`, `ws`, `wd`, `wt`, `wf`, `wb` | Session management plus MoveWord forward / backward | No | Namespace drift: workspace/session and MoveWord share the same prefix |
| `<leader>x` | `xg`, `xr` | CellularAutomaton effects | No | Repo-owned extras/effects namespace |
| `<leader>y` | `yc`, `yy`, `yt` | Yazi cwd / open / toggle | No | Yazi namespace |
| `<leader><Up>`, `<leader><Down>` | `↑`, `↓` | Multicursor skip cursor above / below | No | Only meaningful for multicursor workflow |

### Buffer-local and conditional mappings

| Scope | Key | Current meaning | Overrides builtin | Notes |
| --- | --- | --- | --- | --- |
| LSP-attached buffer | `K` | Pure LSP hover | Yes | Buffer-local registry entry in [lua/user/keymap/buffer.lua](lua/user/keymap/buffer.lua), applied from [lua/user/lsp/handlers.lua](lua/user/lsp/handlers.lua) and shadowing the global ufo `K` |
| Non-LSP buffer | `K` | Peek folded lines, else hover | Yes | Global lazy-registry entry from [lua/user/keymap/lazy.lua](lua/user/keymap/lazy.lua) |
| `qf`, `help`, `man`, `lspinfo`, transient nofile floats | `q` | Close window | Yes | Buffer-local helper from [lua/user/autocommands.lua](lua/user/autocommands.lua) |
| `checkhealth` tab | `q` | Close tab | Yes | Buffer-local helper from [lua/user/autocommands.lua](lua/user/autocommands.lua) with a safe fallback to close the window if it is the last tab |
| Terminal buffers | `<Esc>`, `jk`, `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Leave terminal mode or move between windows | Yes | Buffer-local helpers from [lua/plugins/terminal/toggleterm.lua](lua/plugins/terminal/toggleterm.lua) |
| NvimTree buffer | `P`, `<Esc>`, `<C-f>`, `<C-b>`, `<Tab>` | Preview, close preview, preview scroll, smart expand / preview | Mixed | Repo-local additions only; upstream `default_on_attach()` maps are not expanded here |

### Known drift and conditional precedence

- Global `K` from [lua/user/keymap/lazy.lua](lua/user/keymap/lazy.lua) is shadowed by buffer-local LSP `K` from [lua/user/keymap/buffer.lua](lua/user/keymap/buffer.lua), so fold-preview-on-`K` disappears after LSP attach.
- `<leader>d` is both a standalone Dropbar action and the parent prefix for DAP leaf keys.
- `<leader>w` mixes workspace/session actions with MoveWord (`wf`, `wb`), so the namespace is not semantically pure.

### Conflict detection workflow

Manual tools currently available in this repo:

1. `just keymap-audit` runs the repo-owned headless audit and prints a report without failing the shell.
2. `just keymap-audit-check` runs the same audit but exits non-zero when duplicate repo registrations or required conflict annotations are missing.
3. `just keymap-docs` reports central mappings that do not appear in the README inventory tables.
4. `just keymap-docs-check` exits non-zero when a central registry or which-key mapping is missing from the README inventory tables.
1. `:KeyAnalyzer <leader>`, `:KeyAnalyzer <C->`, and `:KeyAnalyzer <M->` visualize occupied vs free keys by prefix.
2. `:Telescope keymaps` shows the runtime keymap list after lazy loading.
3. `:verbose nmap {lhs}`, `:verbose xmap {lhs}`, `:verbose imap {lhs}`, and friends show which mapping currently wins and where it was defined.

Practical limitations:

- [lua/plugins/keymap/key-analyzer.lua](lua/plugins/keymap/key-analyzer.lua) installs `meznaric/key-analyzer.nvim`, but that plugin is an analysis / visualization aid, not an automatic conflict warning system.
- `just keymap-audit` / `just keymap-audit-check` currently focus on repo-internal duplicate registrations that survive startup and lazy loading, plus missing builtin-conflict annotations, reviewed `conflict.note` metadata for builtin-like normal-mode slots, and missing symbol-family metadata for centralized `[` / `]` and `>` / `<` / `=` entries. They still do not try to infer every upstream plugin default mapping.
- `just keymap-docs` / `just keymap-docs-check` currently cover the centralized plain, lazy, buffer, and which-key registries that back the README inventory tables. Plugin-generated or attach-time families that are still documented only at a coarse summary level remain outside that strict coverage.
- Upstream `key-analyzer.nvim` reads mappings via `vim.api.nvim_get_keymap()`, so it does not fully cover built-in families such as `<C-w>` and `z`, and it does not show buffer-local mappings.
- `which-key.nvim` improves discoverability, but it does not validate conflicts or duplicate ownership.
- There is currently no plugin in this repo that will reliably warn on every repo-internal conflict as soon as a mapping changes, especially across lazy-loaded, plugin-generated, and buffer-local mappings.

If automatic warnings become a requirement, the more reliable next step is a repo-owned audit command or headless script that:

1. collects global and buffer-local mappings,
2. groups them by mode and lhs,
3. flags duplicate lhs ownership,
4. and checks whether builtin overrides or reviewed builtin-like slots are explicitly documented in this section and registry metadata.

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
