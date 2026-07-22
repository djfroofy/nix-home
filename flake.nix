{
  description = "Drew Smathers' standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    work.url = "git+ssh://git@bitbucket.oci.oraclecorp.com:7999/~dsmather/nix-home-work.git?ref=darwin2024";
    personal.url = "github:djfroofy/nix-home-personal";

    workSshConfigs = {
      url = "git+ssh://git@bitbucket.oci.oraclecorp.com:7999/secedge/ssh_configs.git";
      flake = false;
    };
    workOsshConfigs = {
      url = "git+ssh://git@bitbucket.oci.oraclecorp.com:7999/acep/ssh-configs.git";
      flake = false;
    };
    workHpcOps = {
      url = "git+ssh://git@bitbucket.oci.oraclecorp.com:7999/cccp/hpc-ops.git";
      flake = false;
    };
    workSpartaPki = {
      url = "git+ssh://git@bitbucket.oci.oraclecorp.com:7999/secinf/sparta-pki.git";
      flake = false;
    };

    alacritty-theme = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
    nord-tmux = {
      url = "github:arcticicestudio/nord-tmux";
      flake = false;
    };
    base16-rofi = {
      url = "github:djfroofy/base16-rofi/nord-froofy";
      flake = false;
    };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    work,
    personal,
    workSshConfigs,
    workOsshConfigs,
    workHpcOps,
    workSpartaPki,
    alacritty-theme,
    nord-tmux,
    base16-rofi,
    ...
  }: {
    homeConfigurations."dsmather@dsmather-mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
          oraclejdk.accept_license = true;
        };
      };

      modules = [
        ./modules/nix-home-profile.nix
        ./home.nix
        work.homeManagerModules.default
        work.homeManagerModules.dsmather-mac
        personal.homeManagerModules.default
      ];

      extraSpecialArgs = {
        alacrittyTheme = alacritty-theme;
        nordTmux = nord-tmux;
        base16Rofi = base16-rofi;
        karabinerConfig = ./karabiner;
        workAssets = {
          sshConfigs = workSshConfigs;
          osshConfigs = workOsshConfigs;
          hpcOps = workHpcOps;
          spartaPki = workSpartaPki;
        };
      };
    };
  };
}
