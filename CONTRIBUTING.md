# Contributing

This repository is a personal Neovim configuration, not a general-purpose distribution. Contributions are still welcome, but the bar is different from a starter template: small, well-scoped fixes are much more likely to land than broad changes to defaults or taste-driven rewrites.

## Good contribution candidates

- Fixes for breakage caused by upstream plugin or Neovim API changes
- Documentation corrections or missing setup notes
- Isolated improvements to existing modules under `lua/plugins/` or `lua/user/`
- Portability fixes for frontends and terminals already handled by the repo
- Small quality-of-life improvements that do not force a new workflow on every user of the config

Less likely to be a fit:

- Large opinionated remaps
- Wide plugin swaps without a clear maintenance or functional win
- Mass dependency churn without a concrete reason
- Refactors that mostly rename or rearrange code without improving behavior

## Before you open a PR

- Read [README.md](README.md) first so the repository structure and current scope are clear.
- If the change is large or changes defaults, open an issue or draft PR first to check whether it fits the direction of the repo.
- Keep the change focused. Separate bug fixes, formatting changes, and unrelated cleanups into different PRs.

## Suggested workflow

1. Fork the repo and clone your fork.
2. Create a topic branch for one change.
3. Make the smallest change that solves the actual problem.
4. Validate the affected workflow in Neovim.
5. Update docs if the behavior, requirements, or keymaps changed.
6. Open a PR with a clear summary of what changed and how you validated it.

Example clone flow:

```sh
git clone https://github.com/<your-user>/neovim-init.lua.git ~/.config/nvim
cd ~/.config/nvim
git checkout -b fix/<short-description>
```

## Validation expectations

There is no heavy CI pipeline here, so manual verification matters.

For most changes, check the following:

- Start Neovim successfully
- Run `:checkhealth`
- Exercise the feature you changed
- Confirm there are no new warnings or obvious regressions

If your change touches a specific area, validate that area directly:

- LSP changes: verify against at least one real language server setup
- UI or highlight changes: test with the relevant colorscheme or frontend
- Terminal/frontend-specific code: say which client you tested, for example Neovide, Kitty, WezTerm, or Ghostty
- External tool config under `external/`: explain any OS or host assumptions in the PR

## Style guidelines

- Prefer minimal patches over broad rewrites.
- Preserve the existing module layout unless there is a strong reason not to.
- Avoid bundling unrelated lockfile churn with functional changes.
- Keep documentation in sync when you change behavior that users are expected to notice.
- When touching highly personal workflow areas such as keymaps, theme behavior, or frontend-specific UI, explain the tradeoff clearly.

## PR notes

Useful PR descriptions usually include:

- The problem being fixed
- Why the current behavior is wrong or fragile
- The approach taken
- How the change was tested
- Any follow-up work that is intentionally out of scope

If the change is intentionally narrow, say so explicitly. That makes review much easier.
