# AGENTS

## Purpose

This repository manages Home Manager configuration for the author's machines.

- The root repo contains shared configuration and orchestration.
- `work/` contains work-specific Home Manager and related config.
- `personal/` contains non-work and personal productivity config shared across personal environments.
- Treat `work/` and `personal/` as repo boundaries. Keep their changes intentional and separate from root changes unless a task truly spans repos.

## Nix and Home Manager Guidelines

- Prefer small, composable modules over expanding a single large `home.nix`.
- Keep shared behavior in the root repo. Keep environment-specific behavior in `work/` or `personal/`.
- Prefer declarative Home Manager options over ad hoc shell scripting when Home Manager can express the same behavior cleanly.
- Avoid duplicating package lists, option values, or file wiring across modules. Factor common behavior into shared modules or helper expressions.
- Keep the standalone Home Manager flake workflow. Do not add channel-era state or commands.
- Favor changes that will migrate cleanly to flakes later: explicit imports, limited side effects, clear module boundaries, and minimal implicit state.
- When changing package sets or imports, keep evaluation straightforward and predictable. Avoid clever abstractions that make maintenance harder.

## Commands

Current repo workflow is standalone Home Manager with flakes.

- Initial bootstrap: `./setup.sh`
- First activation after login/bootstrap: `./post-setup.sh`
- Validate evaluation/build without activation: `home-manager build --flake .#dsmather@dsmather-mac --no-out-link`
- Apply changes: `home-manager switch --flake .#dsmather@dsmather-mac`
- Safer apply when touching linked files or riskier config: `home-manager switch -b backup --flake .#dsmather@dsmather-mac`
- Sync submodules: `make git-submodule`

## VCS Workflow

- Check `git status --short` before and after changes.
- Keep commits focused. Separate root-repo edits from `work/` or `personal/` edits when possible.
- If submodules move, update them explicitly and ensure the parent repo records the intended submodule revision.
- Do not rewrite unrelated user changes.
- Agent-authored commit messages must end with: `# ai assisted (<coding-agent-name> <coding-agent-version>, <model>)`
- Example: `Blah blah blah # ai assisted (codex-cli 0.118.0, gpt-5)`
- Keep the commit message itself meaningful before that suffix, and place the suffix at the end of the full message.

## Editing Expectations

- Read the local module structure before adding new files or imports.
- Keep user-specific identity and work-specific personal IDs in `user-profile.nix`, not scattered through modules.
- Prefer extending existing patterns only when they remain maintainable; otherwise introduce a cleaner module split.
- Document non-obvious decisions in code comments sparingly and only where they reduce future confusion.
- If a change suggests a broader modernization step, keep the current change compatible and leave the repo easier to migrate later.
