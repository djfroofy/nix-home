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

# drop-in configurations

The setup.sh script below creates 2 subdirecties and stub drop-in nix expressions: (work|personal).nix and packages.nix.

This allows you to easily add custom configuration for personal and work and not worry about
maintaining divergent branches for home and work profiles.

To override work configuration, for example, with a checkout containing nix expressions and other files:

    cd ~/.config/nixpgs
    mv work work.bak
    ln -s ~/Projects/nix-home-work work

For personal configuration:

    cd ~/.config/nixpgs
    mv personal personal.bak
    ln -s ~/Projects/nix-home-personal personal

For an example drop-in see: https://github.com/djfroofy/nix-home-personal
