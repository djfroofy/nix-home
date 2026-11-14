# Linux Home Manager configuration

Standalone flakes for `dsmather@linux` on x86_64 Linux. Requires Nix with
`experimental-features = nix-command flakes`.

```sh
./setup.sh
home-manager build --flake '.#dsmather@linux' --no-out-link
./post-setup.sh
```

The only required drop-in is the pinned personal flake module. All inputs are
public; no work checkout or corporate Git access is required. Ignored sibling
checkouts and initialized submodules are not needed for evaluation.

Linux identity settings live in `user-profile.nix`. Git uses
`drew.smathers@gmail.com`; automatic commit signing is disabled.

For local personal-module development:

```sh
home-manager build --flake '.#dsmather@linux' --override-input personal path:../personal --no-write-lock-file --no-out-link
```

Keep root and personal changes in separate commits. The `flake-migration` branch
is a review candidate; no master merge or Darwin activation is part of validation.

The old channel-based `nixb` alias is retired. Use `nix build nixpkgs#<attribute>`
for an ad hoc package build. Configure Xmobar's wireless interface and CPU
temperature support through `nixHome.profile.linux` in a host profile.

Migration details and validation boundaries are recorded in
[the migration notes](docs/linux-flake-migration.md).
