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

Pending: full x86_64 Linux build, activation at 23.05, transition to 26.05,
repeat activation, shell/Git/link checks and final remote-pinned validation.
Neither candidate branch may be pushed until local VM verification passes.
Hardware tokens, corporate connectivity and graphical behavior are outside
what the VM smoke checks establish.

## Required compatibility changes

- `yubikey-manager-qt` is removed from Nixpkgs 26.05 because upstream archived
  it. Retain `yubikey-manager` CLI; no unrelated GUI is substituted.
- pic-tools upstream is unavailable. Vendor the exact master submodule snapshot
  from the cached Git object; its tree matches Darwin's existing vendored tree.
