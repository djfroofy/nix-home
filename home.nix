{ config, pkgs, ... }:
{
  imports = [
    ./work/home.nix
    ./personal/home.nix
  ];

  home = {
    username = "dsmather";
    homeDirectory = "/home/dsmather";
    stateVersion = "23.05";
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  programs.home-manager = {
    enable = true;
  };


  #services.redshift = {
  #  enable = true;
  #  latitude = "47.679925";
  #  longitude = "-122.268718";
  #};

  # Make holding and release a meta key send key.
  # (Using default which turns CTL keys into escape for vim.
  #services.xcape = {
  #  enable = true;
  #};

  #services.lorri = {
  #  enable = true;
  #};

  #programs.direnv = {
  #  enable = true;
  #};

  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "~/.config/alacritty/themes/themes/nord.yaml"
      ];
      font.size = 7.0;
      shell.program = "fish";
    };
  };


  # VIM editor
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
      vimPlugins.vim-nix
      vimPlugins.vim-better-whitespace
    ];
  };

  # TMUX - terminal multiplexer
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
      /*
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-processes '"~.glances-wrapped" ~vis ~vim ~htop ~journalctl nix-shell "git log" "git diff" "watch" "sudo i7z"'
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
      */
    ];
    extraConfig = ''
      run-shell "~/.nord-tmux/nord.tmux"
    '';
  };


  # Fish Shell - enabled for experimentation
  programs.fish = {
    enable = true;
    shellAliases = import ./shell-aliases.nix;
    functions = {
      fish_greeting = "echo -ns ''";
    };
    plugins = [
      # Plugin to allow sourcing bash/sh files from fish
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "6effb523e4f2f5a4fb4946819796747223666be8";
          sha256 = "1pz8nkk2dl7iim6gi2k7788dhhzi58jw4axx30r5i7052gn4r8w7";
        };
      }
      /*
      {
        name = "tmux.fish";
        src = pkgs.fetchFromGitHub {
          owner = "budimanjojo";
          repo = "tmux.fish";
          rev = "85fdf568a9e169f5cf7449b3220c8aea6a14ee76";
          sha256 = "1a055k8ad1050xm1vw81fwxjm2kb5a2wkg53hby3p2bx1l211d5k";
        };
      }
      */
    ];
  };

  # ZSH shell - disabled for now
  programs.zsh = {
    enable = false;
    shellAliases = import ./shell-aliases.nix;
    oh-my-zsh = {
      enable = false;
      plugins = [
        "git"
        "python"
        "rust"
      ];
      theme = "agnoster";
    };
    initExtra = ''
      eval "$(thefuck --alias)"
    '';
  };

  programs.atuin = {
    enable = false;
    enableFishIntegration = true;
    # enableZshIntegration = true;
  };

  # Git - scm
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    aliases = {
      st = "status -s";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
  };

  # home dot files and directories
  home.file = {
    ".Xmodmap".source = xmonad/Xmodmap;
    ".xmobarrc".source = xmonad/xmobarrc;
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".xmonad/icons".source = xmonad/icons;
    ".xsessionrc".source = xmonad/xsessionrc;
    ".mplayer/config".source = mplayer/config;
    #".config/termite/config".source = nord-termite/src/config;
    ".config/alacritty/themes".source = ./alacritty-theme;
    ".nord-tmux".source = ./nord-tmux;
    ".local/share/rofi/themes".source = ./base16-rofi/themes;
    ".mutt".source = ./mutt;
    ".notmuch-config".source = ./notmuch-config;
    ".urlview".source = ./urlview;
    ".screenlayout".source = ./screenlayout;
    #".task/hooks/on-modify.timewarrior".source = ./timewarrior/on-modify.timewarrior;
    #".task/nord.theme".source = ./igloo/snowblocks/taskwarrior/nord.theme;
    #".timewarrior/nord.theme".source = ./igloo/snowblocks/timewarrior/nord.theme;
    ".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
    "bin".source = ./bin;
  };

}
