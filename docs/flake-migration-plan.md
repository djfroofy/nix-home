<proposed_plan>
# Migrate This Home Manager Setup to Flakes

## Summary
Migrate in three repo layers: make `personal/` and `work/` flake-capable module repos first, then add a root flake that composes them into one standalone Home Manager configuration for the current machine `dsmather-mac` on `aarch64-darwin`. Keep `nix-darwin` out of scope for this first migration. Preserve `work/` and `personal/` as separate repos, and make the root flake pin them by Git while supporting local development via `--override-input`.

## Interfaces and Outputs
- Root repo adds `flake.nix` and `flake.lock`.
- Root flake exports one initial config:
  - `homeConfigurations."dsmather@dsmather-mac"`
- `work/` adds its own `flake.nix` exporting:
  - `homeManagerModules.default`
- `personal/` adds its own `flake.nix` exporting:
  - `homeManagerModules.default`
- New primary commands become:
  - `home-manager build --flake .#dsmather@dsmather-mac`
  - `home-manager switch --flake .#dsmather@dsmather-mac`
- Local nested-repo development uses:
  - `home-manager build --flake .#dsmather@dsmather-mac --override-input work path:./work --override-input personal path:./personal`
  - same pattern for `switch`

## Implementation Changes
- **0. Pre-migration guardrails**
  - Treat `work/` and `personal/` as independent repos that must be committed separately before the root `flake.lock` is finalized.
  - Do not rely on the root repo importing ignored directories directly anymore; that works today only because the setup is channel-based and impure.
  - Keep current user and home path hardcoded for v1:
    - user `dsmather`
    - home `/Users/dsmather`

- **1. Convert `personal/` into a flake-capable module repo**
  - Add `personal/flake.nix` with inputs `nixpkgs` and `home-manager`.
  - Export `homeManagerModules.default = import ./home.nix`.
  - Keep `personal/home.nix` as the behavioral source of truth; do not add host logic there yet.
  - If `personal/` needs packages later, add them inside its own module rather than reaching back into the root repo.

- **2. Convert `work/` into a flake-capable module repo**
  - Add `work/flake.nix` with inputs `nixpkgs` and `home-manager`.
  - Export `homeManagerModules.default`.
  - Move the `work/packages.nix` contribution into the `work` module boundary so the root no longer imports `./work/packages.nix` directly.
  - Keep `work`’s private nested submodules in place, but treat them as part of the `work` input source.
  - When the root references the `work` repo by Git URL, fetch it with submodules enabled so paths used by `work/home.nix` remain available.
  - Preserve current `work` file sources and symlink-backed paths, including SSH configs, `pic-tools`, `nix-utils`, `hpc-ops`, and `trustroots`.

- **3. Refactor the root repo for flake composition**
  - Keep `home.nix` as the shared/root Home Manager module, but remove:
    - `imports = [ ./work/home.nix ./personal/home.nix ]`
    - direct use of `./work/packages.nix`
  - Keep root-owned shared packages in `packages.nix`.
  - Compose the final config from the flake, not from relative imports inside `home.nix`:
    - root shared module
    - `work.homeManagerModules.default`
    - `personal.homeManagerModules.default`
  - Create the root flake with inputs:
    - `nixpkgs`
    - `home-manager`
    - `work` as Git input to the Bitbucket repo
    - `personal` as Git input to the GitHub repo
  - Set `home-manager.inputs.nixpkgs.follows = "nixpkgs"`.
  - Pin `nixpkgs` to a stable channel-compatible flake branch matching the currently working package set.
  - Inline the live `nixpkgs.config` settings in the flake/home-manager configuration:
    - `allowUnfree = true`
    - `oraclejdk.accept_license = true`
  - Do not carry `allowBroken` into the flake unless a concrete package fails without it; `config.nix` is currently unused and should be retired rather than preserved.

- **4. Handle current external source dependencies explicitly**
  - First attempt the migration keeping the root theme/content repos as they are.
  - Validate that a flake build can still see the currently referenced root paths:
    - `./alacritty-theme`
    - `./nord-tmux`
    - `./base16-rofi`
  - If those paths are not reliably visible through the flake source, convert them from git submodule-backed filesystem references into explicit root flake inputs and update `home.file` sources to use those inputs instead of `./...`.
  - Leave inactive/commented dependencies like the currently unused `igloo` and `base16-termite` references alone for the first migration.

- **5. Replace channel-era bootstrap and operator workflow**
  - Rewrite `setup.sh` so it no longer creates `nix-channel` state.
  - Rewrite `post-setup.sh` to call the flake-based switch command.
  - Update `install.sh` to clone the repo, initialize any required submodules, and invoke the flake-based workflow rather than the old channel bootstrap.
  - Update `README.md` to describe:
    - flake prerequisites
    - root `build` and `switch` commands
    - local override-input workflow for `work/` and `personal/`
  - Update `AGENTS.md` command guidance to the flake-based commands.
  - Replace or remove the channel-era shell alias in `shell-aliases.nix`:
    - `nixb = "nix-build '<nixpkgs>' -A"`
    - preferred replacement is a flake-compatible alias or removal if it no longer has a clear repo-specific purpose.

- **6. Locking and commit order**
  - Commit `personal` flake changes in `personal/`.
  - Commit `work` flake changes in `work/`.
  - Test the root flake with local overrides against those checkouts before locking remote revisions.
  - Once validated, generate and commit the root `flake.lock`.
  - Final root commit should include the flake files plus README/script/AGENTS updates.

## Test Plan
- **Nested repo validation**
  - In `personal/`, confirm its flake evaluates and exports the module cleanly.
  - In `work/`, confirm its flake evaluates with its submodule-backed paths present.
- **Root composition validation with local overrides**
  - Run `home-manager build --flake .#dsmather@dsmather-mac --override-input work path:./work --override-input personal path:./personal`
  - Confirm the generated config still includes:
    - shared root packages
    - `work` packages
    - current SSH file wiring
    - current `personal` git identity settings
- **Root composition validation with pinned inputs**
  - After committing `work` and `personal`, remove overrides and run:
    - `home-manager build --flake .#dsmather@dsmather-mac`
  - Then run:
    - `home-manager switch --flake .#dsmather@dsmather-mac`
- **Regression checks**
  - Verify `~/.ssh/config`, `~/.ssh/cpv.ssh_config`, `.codex/config.toml`, `.config/alacritty/themes`, `.nord-tmux`, and `workbin` are still linked.
  - Verify the CPV SSH behavior still works after the flake migration.
  - Verify no part of the new workflow depends on `nix-channel` or `<nixpkgs>`.

## Assumptions
- First migration target is the current Darwin arm64 machine only.
- `work/` and `personal/` remain separate repos rather than becoming top-level submodules or being folded into the root repo.
- `work` and `personal` will each gain a minimal flake interface rather than staying as raw source trees.
- Local uncommitted work in nested repos should be testable via `--override-input`, but the root `flake.lock` should pin committed remote revisions.
- `nix-darwin` is deferred until after the standalone Home Manager flake is stable.
</proposed_plan>
