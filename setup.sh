#!/run/current-system/sw/bin/bash

set -euf -o pipefail

if [[ -d work ]]; then
   echo backing up work to _work.back
   mv work _work.back
fi
mkdir -p work/bin
echo "{ ... }: {}" > work/work.nix
echo "================================================================"
echo "Created stub directory for work configurations. At a later point"
echo "you can backup and symlink in prefered work configurations. Ex:"
echo "    cd ~/.config/nixpgs"
echo "    rm -rf work"
echo "    ln -s ~/Projects/nix-home-work work"
echo "================================================================"

nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update home-manager

make git-submodule

echo "================================================================"
echo done with first part of setup.
echo now log out, log back in and run:
echo ./post-setup.sh


