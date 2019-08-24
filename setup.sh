#!/run/current-system/sw/bin/bash

set -euf -o pipefail

nix-channel --add https://github.com/rycee/home-manager/archive/release-18.09.tar.gz home-manager
nix-channel --update home-manager


