# nix-home
Nix home-manager configuration for my computers.

To recreate home on another first create a .config directory in your home and clone
this project there:

    cd ~
    mkdir -p .config
    cd .config
    git clone git@github.com:djfroofy/nix-home.git nixpkgs

Now run first pass setup:

    cd ~/.config/nixpkgs
    ./setup.sh

Log out and log back in and run:

    ./post-setup.sh

This is mostly tested on NixOS 19.09 along with the following configuration: https://github.com/djfroofy/nix-configuration
On other Linux systems, ymmv definitely.

For more details on home-manager for nix, see: https://github.com/rycee/home-manager
