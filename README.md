# nix-home
Nix home-manager configuration for my desktop.

To recreate home on another machine:

    curl https://raw.githubusercontent.com/djfroofy/nix-home/f562e56b900825ee8d7c3789f5878d6b1c1b3e6d/install.sh -O && [[ $(sha256sum install.sh  | awk '{print $1}') == 9d0b7c238f60dbec9e69ccac6afc338232bdee5ab50236f7d03bb484b9779746 ]] && chmod +x install.sh && ./install.sh

See also my nixos configuration which this is tested against: https://github.com/djfroofy/nix-configuration

For more details on home-manager for nix, see: https://github.com/rycee/home-manager


