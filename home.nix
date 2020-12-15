{ config, pkgs, ... }:
{
  imports = [
    ./work/home.nix
    ./personal/home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

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

  services.lorri = {
    enable = true;
  };

  programs.direnv = {
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
      vimPlugins.vim-nix
      vimPlugins.vim-better-whitespace
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
    initExtra = ''
      eval "$(thefuck --alias)"
    '';
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    aliases = {
      st = "status -s";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
  };

  programs.home-manager = {
    enable = true;
  };


  home.file = {
    ".Xmodmap".source = xmonad/Xmodmap;
    ".xmobarrc".source = xmonad/xmobarrc;
    ".xmonad/xmonad.hs".source = xmonad/xmonad.hs;
    ".xmonad/icons".source = xmonad/icons;
    ".xsessionrc".source = xmonad/xsessionrc;
    ".mplayer/config".source = mplayer/config;
    ".config/termite/config".source = nord-termite/src/config;
    ".nord-tmux".source = ./nord-tmux;
    ".local/share/rofi/themes".source = ./base16-rofi/themes;
    ".mutt".source = ./mutt;
    ".notmuch-config".source = ./notmuch-config;
    ".urlview".source = ./urlview;
    ".screenlayout".source = ./screenlayout;
    ".task/hooks/on-modify.timewarrior".source = ./timewarrior/on-modify.timewarrior;
    ".task/nord.theme".source = ./igloo/snowblocks/taskwarrior/nord.theme;
    ".timewarrior/nord.theme".source = ./igloo/snowblocks/timewarrior/nord.theme;
    ".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
    "bin".source = ./bin;
  };

}
