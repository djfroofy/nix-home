{ config, pkgs, ... }:


{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  nixpkgs.config.packageOverrides = pkgs: { 
     nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
	inherit pkgs;
     };
   };

  home.packages = with pkgs; [

    # Screenshots, Screencasts
    vokoscreen
    xmobar
    arandr
    haskellPackages.xmonad-wallpaper
    feh
    acpi
    # dmenu replacement task launcher
    rofi
    
    # Keyboard stuff
    xsel
    xclip
    dmenu
    maim
    xdotool
    slop

    # Screen, Mouse sharing
    # synergy

    # Chatting
    # slack-term

    # Health and Well-being
    redshift

    # ---
    # Development
    # ----

    # General
    gnumake
    direnv
    minicom
    broot

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
    samplv1
    # chuck
    ardour
    qjackctl
    bitwig-studio
    AMB-plugins
    caps
    ladspaPlugins
    zam-plugins

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

    unrar
    xorg.xdpyinfo
  ];


  services.redshift = {
    enable = true;
    latitude = "47.679925";
    longitude = "-122.268718";
  };

  # Make holding and release a meta key send key.
  # (Using default which turns CTL keys into escape for vim.
  services.xcape = {
    enable = true;
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    settings = {
      relativenumber = true;
      number = true;
    };
    plugins = with pkgs; [
      vimPlugins.supertab
      vimPlugins.The_NERD_tree # file system explorer
      vimPlugins.rust-vim
      vimPlugins.vim-racer
      vimPlugins.lightline-vim
      vimPlugins.nord-vim
      vimPlugins.vim-gitgutter
    ];
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.fpp
      tmuxPlugins.copycat
      tmuxPlugins.open
      tmuxPlugins.cpu
      tmuxPlugins.pain-control
      tmuxPlugins.sidebar
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-processes '"~.glances-wrapped" ~vim ~htop ~journalctl nix-shell "git log" "git diff"'
          set -g @resurrect-save-shell-history 'off'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1'
          set -g @continuum-boot 'on'
          bind-key a set-window-option synchronize-panes
          '';
      }
    ];
    extraConfig = ''
      run-shell "~/.nord-tmux/nord.tmux"
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      gpom = "git push origin master";
      nso = "nix-store --optimise -v";
      gcold = "nix-collect-garbage --delete-older-than 30d";
      sgcold = "sudo nix-collect-garbage --delete-older-than 30d";
      nbz = "cd ~/Projects/nix-buildzones";
      lolj = "sudo journalctl -f | lolcat";
      nixb = "nix-build '<nixpkgs>' -A";
      nature_video = "mplayer -vf delogo=1598:99:254:65:0 $HOME/videos/nature.webm";
      campfire_video = "mplayer -vf delogo=1110:653:150:50:0 $HOME/videos/campfire.mp4";
      sdana = "mkdir -p $HOME/systemd-analyze; systemd-analyze plot > $HOME/systemd-analyze/analysis-$(date +%Y%m%d-%H%M).svg";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "rust"
      ];
      theme = "agnoster";
    };
  };
  
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Drew Smathers";
    userEmail = "drew.smathers@gmail.com";
    aliases = {
      st = "status -s";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
  };

  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      https-everywhere
    ];
  };


  home.file = {
    ".Xmodmap".source = xmonad/Xmodmap;
    ".xmobarrc".source = xmonad/xmobarrc;
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".xsessionrc".source = xmonad/xsessionrc;
    ".mplayer/config".source = mplayer/config;
    #".slack-term".source = chat/slack-term;
    ".config/termite/config".source = nord-termite/src/config;
    ".nord-tmux".source = ./nord-tmux;
    ".local/share/rofi/themes".source = ./base16-rofi/themes;
    "bin".source = ./bin;
  };
 
}
