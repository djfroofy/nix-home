# Karabiner Right-Hand One-Hand QWERTY Setup

## Summary

Add a Home Manager-managed Karabiner configuration for right-hand one-handed QWERTY typing, using Karabiner-Elements installed via Homebrew cask.

## Key Changes

- Add a repo-managed `karabiner/` directory containing `karabiner.json`.
- Link it through Home Manager as `home.file.".config/karabiner".source = ../karabiner;` from `personal/home.nix`.
- Install Karabiner-Elements via Homebrew cask because the current repo does not declaratively manage Homebrew casks and Karabiner ships as a macOS package with privileged components.

## Karabiner Behavior

- Use one profile named `Default`.
- Add one complex modification rule: `Right-hand one-handed QWERTY with Space layer`.
- Tap `spacebar` to send normal space.
- Hold `spacebar` while pressing a right-side key to send the mirrored left-side QWERTY key.
- Initial mirror mappings:
  - `y -> t`, `u -> r`, `i -> e`, `o -> w`, `p -> q`
  - `h -> g`, `j -> f`, `k -> d`, `l -> s`, `semicolon -> a`
  - `n -> b`, `m -> v`, `comma -> c`, `period -> x`, `slash -> z`
  - `6 -> 5`, `7 -> 4`, `8 -> 3`, `9 -> 2`, `0 -> 1`

## Test Plan

- Check `git status --short` before and after; leave unrelated untracked files untouched.
- Validate JSON with `jq empty karabiner/karabiner.json`.
- Validate Home Manager evaluation with `home-manager build`.
- Install with `brew install --cask karabiner-elements`.
- Activate with `home-manager switch`.
- Launch Karabiner-Elements once and approve required macOS permissions manually.
- Use Karabiner EventViewer to verify tapped space, held-space mappings, and shifted mirrored letters.

## Assumptions

- The first version optimizes for right-hand typing on a standard US QWERTY layout.
- Hold-space mode is the selected activation behavior.
- Homebrew cask is the selected install method.
- The change does not introduce nix-darwin or declarative Homebrew management.
