# Return Codex to Cask Install With Writable Trust State

## Summary

Move back to the Homebrew cask Codex install, migrate the Codex config to the newer profile-file format, and stop linking `~/.codex/config.toml` directly into the Nix store. The live user config will become a normal writable file so the newer Codex TUI can persist project trust without failing on `config/batchWrite`.

## Key Changes

- Uninstall global npm `@openai/codex`.
- Install `codex` via Homebrew cask and record that choice in a root `Brewfile`.
- Remove legacy `profile = "act"` and `[profiles.*]` tables from `work/codex/config.toml`.
- Keep global defaults, MCP servers, telemetry, features, and durable trusted projects in `work/codex/config.toml`.
- Create separate profile files in `work/codex/` for `act`, `plan`, `review`, `codex`, `devfast`, `quick`, `nano`, and `pro`.
- Replace the read-only Home Manager link for `~/.codex/config.toml` with an activation step that installs it as a normal writable file and refreshes it only when the source hash changes.
- Keep profile files Home Manager-managed beside `config.toml`; they can remain read-only because Codex only reads selected profile layers.
- Add durable trust entries for `/Users/dsmather/Projects/oci-stability-learning`, `/Users/dsmather/.config/home-manager`, and `/tmp`.

## Test Plan

- Run `home-manager build`.
- Run `home-manager switch -b backup`.
- Verify `codex --version`, `brew list --cask codex`, and `npm list -g @openai/codex --depth=0`.
- Verify `test ! -L ~/.codex/config.toml` and `test -w ~/.codex/config.toml`.
- Verify `codex --profile act features list` loads without the legacy profile error.
- Verify `find ~/.codex -maxdepth 1 -name '*.config.toml'` shows the expected profile files.
- Launch Codex from `/Users/dsmather/Projects/oci-stability-learning` and confirm it no longer fails with `Failed to set trust ... config/batchWrite failed in TUI`.
- Finish with `git diff --check` in the root repo and `work/`.

## Assumptions

- Runtime trust entries Codex appends are local machine state.
- Runtime trust entries may be replaced when the declarative source config changes and Home Manager refreshes the live file.
- No commit is created unless explicitly requested after implementation.
