#!/run/current-system/sw/bin/bash

set -euf -o pipefail

nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update home-manager

make git-submodule

echo done with first part of setup.
echo now log out, log back in and run:
echo ./post-setup.sh


