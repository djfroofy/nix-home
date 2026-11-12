{ config, pkgs, alacrittyTheme, nordTmux, base16Rofi, ... }:

{
  home = {
    username = config.nixHome.profile.identity.username;
    homeDirectory = config.nixHome.profile.identity.homeDirectory;
    stateVersion = "23.05";
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.ghostty = {
    enable = true;

    # Enable whichever shell(s) you use
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Nord";
      # optional extras
      font-size = 12;
      background-opacity = 0.95;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.config/alacritty/themes/themes/nord.yaml"
      ];
      font.size = 7.0;
      terminal.shell.program = "${pkgs.fish}/bin/fish";
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
      vimPlugins.nerdtree # file system explorer
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
    #package = pkgs.gitAndTools.gitFull;
    enable = true;
    lfs.enable = true;
    settings.alias = {
      st = "status -s";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
  };

  # home dot files and directories
  home.file = {
    ".Xmodmap".source = xmonad/Xmodmap;
    ".xmobarrc".text = builtins.replaceStrings
      [ "{wiiface}" "{temp}" ]
      [ config.nixHome.profile.linux.wifiInterface
        (if config.nixHome.profile.linux.cpuTemperature then "%multicoretemp% | " else "") ]
      (builtins.readFile ./xmonad/xmobar.hs);
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".xmonad/icons".source = xmonad/icons;
    ".xsessionrc".source = xmonad/xsessionrc;
    ".mplayer/config".source = mplayer/config;
    #".config/termite/config".source = nord-termite/src/config;
    ".config/alacritty/themes".source = alacrittyTheme;
    ".nord-tmux".source = nordTmux;
    ".local/share/rofi/themes".source = base16Rofi + "/themes";
    ".mutt".source = ./mutt;
    ".notmuch-config".source = ./notmuch-config;
    ".urlview".source = ./urlview;
    ".screenlayout".source = ./screenlayout;
    ".config/nixpkgs/config.nix".source = ./config.nix;
    #".task/hooks/on-modify.timewarrior".source = ./timewarrior/on-modify.timewarrior;
    #".task/nord.theme".source = ./igloo/snowblocks/taskwarrior/nord.theme;
    #".timewarrior/nord.theme".source = ./igloo/snowblocks/timewarrior/nord.theme;
    ".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
    "bin".source = ./bin;
  };

}
