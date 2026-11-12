# Linux flake migration validation

## Source boundaries

Root base: `fb2b8acd63a1336a3f9c0a31795cc68ea9c3b2a6`.
Work base: `95a3d336f389843611930e91158ddcbc13ae241d`.
The existing Darwin checkouts and personal working tree are excluded.
Linux retains its X11 links, Fish setup, terminal settings and work helpers.
External assets use the original master gitlink revisions where available.
The missing generated trustroots directory uses the Sparta source pinned by Darwin.
The legacy NixOS certificate module is not a standalone Home Manager module.

## State-version audit

Reviewed the upstream release notes for every release after 23.05 through 26.05:
https://github.com/nix-community/home-manager/tree/release-26.05/docs/release-notes

- 23.11, 24.05, 24.11: no documented state-version changes.
- 25.05: Git signing format loses its implicit OpenPGP default. The pinned
  personal module explicitly selects OpenPGP. Automatic commit signing is
  explicitly disabled in root; the format alone does not enable signing.
- 25.11: password-store path and Darwin app-copy defaults change. Neither module
  is enabled in this Linux configuration.
- 26.05: GTK4, Zsh/XDG, Yazi, XDG user directories, Darwin man, Neovim,
  Firefox, Hyprland, Docker/Colima, auto-upgrade and Mergiraf defaults change.
  These modules are not enabled here. Zsh is explicitly disabled; Vim is used.
  No existing application data is deliberately relocated.

The state-version change is separate from the flake composition commit.
A clean VM transition cannot certify migration of undiscovered state on an
existing Linux workstation. Review its enabled modules before deployment.

## Verification gate

Passed in the x86_64 Ubuntu 24.04 Lima VM: full build and activation at
23.05, transition to 26.05, repeat activation, and three successful runs of
`scripts/verify-linux-home.sh`. Checks cover managed links, command availability,
Fish login, Git identity and an unsigned commit without overrides.
Final remote-pinned validation is required before root publication.
Hardware tokens, corporate connectivity and graphical behavior are outside
what the VM smoke checks establish.

## Required compatibility changes

- `yubikey-manager-qt` is removed from Nixpkgs 26.05 because upstream archived
  it. Retain `yubikey-manager` CLI; no unrelated GUI is substituted.
- pic-tools upstream is unavailable. Vendor the exact master submodule snapshot
  from the cached Git object; its tree matches Darwin's existing vendored tree.
- `pcsctools` is renamed to `pcsc-tools`.
- Xmobar previously referenced an ignored, absent generated file. Home Manager now
  renders the tracked template; `nixHome.profile.linux.wifiInterface` defaults to
  empty for hosts without Wi-Fi and `cpuTemperature` defaults to true. Set those
  profile options for the target workstation (disable CPU temperature on unsupported CPUs).
- Alacritty uses its current `general.import` and `terminal.shell` settings.
- Git aliases use Git's `alias` section rather than the ineffective `aliases` section.

## Local verification evidence

Host evaluation succeeded for the full activation derivation. Evaluated package
lists, managed file definitions, Git settings and session variables match across
23.05 and 26.05 after normalizing root source-store prefixes.
Bootstrap and validation shell scripts passed `bash -n`.

Nix detected a hash mismatch in the host's existing Sparta source store path.
Re-exporting the pinned commit directly from the cached Git repository into the
VM reproduced the lockfile's exact NAR hash:
`sha256-WPokg6szmTA2KuwC2ZCkolVTySyJ+aEQDEuXa3LngqY=`.
No host store path was rewritten to bypass the check.

VM access: `limactl shell flake-migration -- sudo -iu dsmather`.
Validation logs are retained beside the host worktrees in
`/private/tmp/home-manager-worktrees/` (`vm-build-2305.log` and `vm-transition.log`).
The host required Lima's additional guest-agent package, which also upgraded
Lima/QEMU and their Homebrew dependencies. No macOS Home Manager activation ran.
The old `nixb` alias is retired; use `nix build nixpkgs#<attribute>`.
