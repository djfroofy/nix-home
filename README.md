# Linux Home Manager configuration

Standalone flakes for `dsmather@linux` on x86_64 Linux. Requires Nix with
`experimental-features = nix-command flakes` and host access to the private work inputs.

```sh
./setup.sh
home-manager build --flake '.#dsmather@linux' --no-out-link
./post-setup.sh
```

The root flake pins work, personal and external assets. Ignored sibling checkouts
and initialized submodules are not needed for evaluation.

For local work-module development:

```sh
home-manager build --flake '.#dsmather@linux' --override-input work path:../work --no-write-lock-file --no-out-link
```

Keep root and work changes in separate commits. `flake-migration` branches are
review candidates; no master merge or Darwin activation is part of validation.

The old channel-based `nixb` alias is retired. Use `nix build nixpkgs#<attribute>`
for an ad hoc package build. Configure Xmobar's wireless interface and CPU
temperature support through `nixHome.profile.linux` in a host profile.

Migration details and validation boundaries are recorded in
[the migration notes](docs/linux-flake-migration.md).
