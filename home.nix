{ config, pkgs, ... }:


{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };


  nixpkgs.overlays = [
    (self: super:
    {
      oracledjk8 = super.oraclejdk8.override {
        # Download from Oracle website
        src = ./jdk-8u201-linux-x64.tar.gz;
      };
    })
  ];


  home.packages = with pkgs; [

    # Screenshots, Screencasts
    flameshot
    vokoscreen

    # Screen, Mouse sharing
    synergy

    # Chatting
    slack-term

    # Health and Well-being
    redshift

    # ---
    # Development
    # ----

    # General
    gnumake
    direnv
    minicom
    xsel

    # Java
    maven
    oraclejdk8

    # C
    gcc

    # Python and python packages
    python
    python27Packages.virtualenv
    python27Packages.pykickstart

    python37
    python37Packages.virtualenv
    python37Packages.glances

    # Ruby
    ruby

    # Haskell
    ghc
    haskellPackages.xmonad-contrib

    # Code editors, IDEs 
    vscode

    # Rust
    rustc
    rustPlatform.rustcSrc
    cargo
    carnix

    # Shells, remote debugging 
    mosh

    # ---
    # AV and Games
    # ---

    # Audio
    pamixer
    paprefs
    alsaLib
    #fluidsynth
    #soundfont-fluid
    jack2
    jack_rack
    timemachine
    audacity
    # chuck
    ardour
    qjackctl
    bitwig-studio

    # Photo Editing
    gimp
    blender

    # Bling
    almonds

    # Video
    ffmpeg
    mpv
    gimp
    youtube-dl
    (pkgs.mplayer.override { jackaudioSupport = true; })
    #(pkgs.mpv.override { jackaudioSupport = true; })
    #(pkgs.blender.override { jackaudioSupport = true; })

    # Games, GFX Demos etc
    minetest
    glxinfo
    gtypist
    maim

    # Misc others
    mimic
    rpm
    fceux
    nixops
    radeontop
    go-md2man

    # electronics projects
    arduino
    fritzing
    ino
  ];


  services.redshift = {
    enable = true;
    latitude = "47.679925";
    longitude = "-122.268718";
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    settings = {
      relativenumber = true;
      number = true;
    };
    plugins = [
      "sensible"
      "supertab"
      "The_NERD_tree" # file system explorer
      "rust-vim"
      "vim-racer"
    ];
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.fpp
      tmuxPlugins.battery
      tmuxPlugins.copycat
      tmuxPlugins.continuum
      tmuxPlugins.open
      tmuxPlugins.cpu
      tmuxPlugins.pain-control
    ];
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [ "git" "python" "rust" "carg" "nix-shell" ];
    theme = "agnoster";
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
    ".zshrc.local".source = zsh/zshrc.local;
    ".mplayer/config".source = mplayer/config;
    ".slack-term".source = chat/slack-term;
    "bin".source = ./bin;
  };
 
}
