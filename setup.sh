#!/usr/bin/env bash

set -euf -o pipefail

clone_if_missing() {
        local directory="$1"
        local repository="$2"

        if [[ -d "${directory}/.git" || -f "${directory}/.git" ]]
        then
                echo "${directory} checkout already exists, skipping"
        else
                git clone "${repository}" "${directory}"
        fi
}

clone_if_missing work ssh://git@bitbucket.oci.oraclecorp.com:7999/~dsmather/nix-home-work.git
clone_if_missing personal git@github.com:djfroofy/nix-home-personal.git

make git-submodule
git -C work submodule sync --recursive
git -C work submodule update --init --recursive --progress

echo "================================================================"
echo "Bootstrap complete. Verify the flake with:"
echo "  home-manager build --flake .#dsmather@dsmather-mac --no-out-link"
echo "Then activate it with:"
echo "  home-manager switch -b backup --flake .#dsmather@dsmather-mac"
