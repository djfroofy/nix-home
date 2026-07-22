#!/usr/bin/env bash

set -euf -o pipefail

config_root="${HOME}/.config/home-manager"

mkdir -p "${HOME}/.config"
git clone git@github.com:djfroofy/nix-home.git "${config_root}"
cd "${config_root}"
./setup.sh
echo "Install completed. Run ./post-setup.sh to activate the Home Manager flake."
