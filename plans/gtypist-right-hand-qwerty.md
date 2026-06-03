# Add Gtypist Right-Hand QWERTY Drills

## Summary

Add GNU Typist (`gtypist`) to the Home Manager package set and add a repo-managed custom lesson file for the Karabiner right-hand mirror layout.

## Key Changes

- Add `gtypist` in root `packages.nix`.
- Add `gtypist/right-hand-qwerty.typ` with short tutorial text, practice drills, and sentence practice.
- Add `bin/gtypist-right-hand-qwerty` wrapper.
- Link the lesson directory via Home Manager at `~/.config/gtypist`.
- Link the wrapper via Home Manager at `~/.local/bin/gtypist-right-hand-qwerty` so it is on the active PATH.

## Drill Content

- Include the mirrored mapping reference in the first tutorial screen.
- Add progressive home row, top row, bottom row, number row, word, mixed word, and sentence drills.
- Show normal QWERTY target text, while assuming the user holds Space for mirrored left-side letters through Karabiner.

## Test Plan

- Run `home-manager build`.
- Smoke-test the generated `gtypist` binary with the custom lesson and confirm it loads the first tutorial screen.
- Run `home-manager switch`.
- Confirm `gtypist` and `gtypist-right-hand-qwerty` resolve from `PATH`.
- Confirm `~/.config/gtypist/right-hand-qwerty.typ` exists through the Home Manager link.

## Assumptions

- The drills should show normal QWERTY output letters, not physical right-hand keys.
- The user will hold Space for mirrored keys while completing the exercises.
- The change should not touch unrelated dirty `work/` repo state.
