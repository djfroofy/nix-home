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
    pkgs.ardour
    pkgs.jack2
    pkgs.qjackctl
    pkgs.flameshot
    pkgs.timemachine
    pkgs.mimic
    pkgs.rpm
    pkgs.fceux
    pkgs.nixops
    pkgs.radeontop
    pkgs.go-md2man
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
    ".Xmodmap".source = xmonad/Xmodmap;
    ".xmobarrc".source = xmonad/xmobarrc;
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".zshrc".source = zsh/zshrc;
    ".mplayer/config".source = mplayer/config;
    ".tmux.conf".source = tmux/tmux.conf;
    ".tmux.conf.local".source = tmux/tmux.conf.local;
  };
 
}
