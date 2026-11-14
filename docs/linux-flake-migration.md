# Personal-only Linux flake migration

## Composition

The Linux root requires only the personal flake module. Work and its private
asset inputs are removed; unrelated public input revisions remain pinned.
The work and personal repositories and Darwin checkouts are unchanged.

The root `user-profile.nix` supplies Drew Smathers' Linux identity, including
`drew.smathers@gmail.com` and `/home/dsmather`. Its signing key is empty and
automatic commit signing remains disabled. The personal module's macOS
Karabiner link remains disabled on Linux. State version stays at 26.05.

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

## Verification

The earlier work-enabled migration passed full x86_64 VM builds, the state-version
transition and repeat activation. On 2026-11-13 the personal-only update also passed an offline build, transition
from that work-enabled generation, repeat activation, and two successful runs
of `scripts/verify-linux-home.sh`. The checks verified shared links, Fish,
personal Git identity, unsigned commits, and removal of the old work-managed
links and `boci` function. The flake metadata resolved offline using only public
inputs, and all retained lockfile input nodes were unchanged. No corporate Git
inputs or local input overrides are needed by the new flake.

VM: `limactl shell flake-migration -- sudo -iu dsmather`.
Logs: `/private/tmp/home-manager-worktrees/vm-personal-only.log` (transition and
repeat activation), and `vm-personal-only-final.log` (committed-source verification).
Graphical behavior and physical devices are outside the VM smoke checks.

## Compatibility retained

Xmobar is rendered from its tracked template. Set `nixHome.profile.linux` options
for the workstation's Wi-Fi interface and CPU temperature support. Alacritty uses
its current settings structure. Git aliases use the `alias` section, and the
old channel-based `nixb` alias remains retired.
