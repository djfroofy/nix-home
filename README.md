# nix-home

Standalone Home Manager flake configuration for `dsmather@dsmather-mac` on Apple
Silicon macOS. The root repository composes shared configuration with pinned private
`work` and `personal` module repositories.

## Prerequisites

- Nix with `nix-command` and `flakes` enabled.
- Home Manager installed for the current user.
- SSH access to the private work repository and its submodules.

## Bootstrap

    git clone git@github.com:djfroofy/nix-home.git ~/.config/home-manager
    cd ~/.config/home-manager
    ./setup.sh

`setup.sh` clones the `work` and `personal` module repositories when missing and
initializes root and work submodules. The machine-specific profile lives in the
private work repository at `user-profile.nix`.

## Build and activate

    home-manager build --flake .#dsmather@dsmather-mac --no-out-link
    home-manager switch -b backup --flake .#dsmather@dsmather-mac

The first activation uses a backup generation because this configuration manages
existing files in the home directory.

## Nested module development

The committed root lock pins remote revisions. To test local work before committing
and publishing the nested repositories, override their inputs:

    home-manager build --flake .#dsmather@dsmather-mac --no-out-link \
      --override-input work "git+file:///Users/dsmather/.config/home-manager/work?submodules=1" \
      --override-input personal "git+file:///Users/dsmather/.config/home-manager/personal"

Update one dependency at a time with `nix flake update <input>`, then rebuild and
commit the resulting `flake.lock` only after validation succeeds.
