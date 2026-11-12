#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.nix-profile/bin:$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$PATH"
test "$(id -un)" = dsmather
test "$HOME" = /home/dsmather
for path in .Xmodmap .xmobarrc .xmonad/xmonad.hs .config/alacritty/themes .nord-tmux .pic-tools .ssh/config workbin sparta_roots; do
  test -L "$HOME/$path"
  test -e "$HOME/$path"
done
test ! -e "$HOME/.config/karabiner"
test "$(git config --get commit.gpgsign)" = false
test "$(git config --get user.name)" = 'Drew Smathers'
for command in git fish vim tmux ykman pcsc_scan go; do
  command -v "$command"
done
fish --login --command 'functions -q boci; and command -q git; and command -q ykman'
verification_dir=$(mktemp -d)
trap 'rm -rf "$verification_dir"' EXIT
git init -q "$verification_dir"
git -C "$verification_dir" commit --allow-empty -qm 'Verify unsigned agent commit'
if git -C "$verification_dir" cat-file -p HEAD | grep -q '^gpgsig '; then
  echo 'Unexpected commit signature' >&2
  exit 1
fi
printf '%s\n' 'Linux home smoke checks passed.'
