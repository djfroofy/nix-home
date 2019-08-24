#!/run/current-system/sw/bin/bash

set -euf -o pipefail

cd ~
mkdir -p .config
cd .config
git clone https://github.com/djfroofy/nix-home.git nixpkgs
cd nixpkgs
./setup.sh
echo "Install completed. Log out and log in and then run ./install-post.sh"
