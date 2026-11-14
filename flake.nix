{
  description = "Standalone Linux Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    personal.url = "github:djfroofy/nix-home-personal/974f58bf2a3867f5348dd2320ceabec5517ce403";
    alacritty-theme = { url = "github:alacritty/alacritty-theme/9f769d54eccc0b43bb1ae600575baddea15aae56"; flake = false; };
    nord-tmux = { url = "github:arcticicestudio/nord-tmux/b0fd5838dbd5f3cf55eefd83ac84f3f9ac076610"; flake = false; };
    base16-rofi = { url = "github:djfroofy/base16-rofi/4e73caf3da17f3946657a87cf082f215047f508e"; flake = false; };
  };
  outputs = inputs: {
    homeConfigurations."dsmather@linux" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; oraclejdk.accept_license = true; };
      };
      modules = [
        ./modules/nix-home-profile.nix
        ./user-profile.nix
        ./home.nix
        inputs.personal.homeManagerModules.default
        ({ ... }: {
          # Personal currently declares a macOS-only asset unconditionally.
          home.file.".config/karabiner".enable = false;
          programs.git.settings.commit.gpgsign = false;
        })
      ];
      extraSpecialArgs = {
        alacrittyTheme = inputs.alacritty-theme;
        nordTmux = inputs.nord-tmux;
        base16Rofi = inputs.base16-rofi;
        karabinerConfig = ./linux-assets; # Unused because the Linux link is disabled.
      };
    };
  };
}
