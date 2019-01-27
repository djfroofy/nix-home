{ config, pkgs, ... }:


{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.gimp
    pkgs.youtube-dl
    pkgs.mosh
    pkgs.vscode
  ];


  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    settings = {
      relativenumber = true;
      number = true;
    };
    plugins = [
      "sensible"
      "The_NERD_tree" # file system explorer
      "rust-vim"
    ];
    
  };
  
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Drew Smathers";
    userEmail = "drew.smathers@gmail.com";
    extraConfig = builtins.readFile git/gitconfig;
  };

  home.file = {
    ".xmobarrc".source = xmonad/xmobarrc;
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".zshrc".source = zsh/zshrc;
  };
 
}
