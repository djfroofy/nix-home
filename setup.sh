#!/run/current-system/sw/bin/bash

set -euf -o pipefail

for dropin in work personal
do
        if [[ -d "${dropin}" ]]
        then
                echo Drop-in ${dropin} already exists, skipping
        else
                mkdir -p ${dropin}
                echo "{ ... }: {}" > ${dropin}/${dropin}.nix
                echo "================================================================"
                echo "Created stub directory for your ${dropin} configurations. At a later point"
                echo "you can backup and symlink in prefered ${dropin} configurations. Ex:"
                echo "    cd ~/.config/nixpgs"
                echo "    mv ${dropin} ${dropin}.bak"
                echo "    ln -s ~/Projects/nix-home-${dropin} ${dropin}"
                echo "================================================================"
        fi
done

nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update home-manager

make git-submodule

echo "================================================================"
echo done with first part of setup.
echo now log out, log back in and run:
echo ./post-setup.sh


