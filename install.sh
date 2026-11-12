#!/usr/bin/env bash

set -euf -o pipefail

cd ~
mkdir -p .config
cd .config
git clone --branch flake-migration https://github.com/djfroofy/nix-home.git nixpkgs
cd nixpkgs
./setup.sh
echo "Install completed. Log out and log in and then run ./post-setup.sh"
