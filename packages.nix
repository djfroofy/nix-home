#let ff69pkgs = (import ./nixpkgs-ff69 {});
#(builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
#  name = "ff69";
#  url = https://github.com/NixOS/nixpkgs.git;
  # Commit hash for nixos-unstable as of 2018-09-12
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
#  rev = "fec43936b45fe738b850686646e49ca12b3749a5";}) {});
#in
pkgs: with pkgs; [
  fastfetch
  feh
  xv
  fortune
  tree
  nix-prefetch-git

  socat
  zip
  unzip
  mkpasswd
  dnsmasq
  htop
  pciutils
  lolcat
  jq
  tre
  wget
  file
  lsof

  # Performance Testing
  sysbench

  ffmpeg
  imagemagick

  # General
  gnumake
  gcc
  cmake
  direnv
  minicom
  broot
  neofetch
  fastfetch
  dnsutils

  # Java
  # maven
  #oraclejdk8

  # Python and python packages
  #python
  python3
  #python27Packages.virtualenv
  #python311
  #python311Packages.virtualenv
  # comment the next line out when on unstable
  # python37Packages.glances
  #glances
  #python37Packages.mysql-connector

  # ucomment the next line when on unstable
  #glances

  # code review stuff
  # arcanist

  # Ruby
  #ruby

  # Go
  #go
  #protobuf

  # Haskell
  #ghc

  # Code editors, IDEs
  #vscode

  # Rust
  #rustc
  #rustPlatform.rustcSrc
  #cargo
  #carnix

  # SCM
  #github-cli

  # java development
  #eclipses.eclipse-java
  #jetbrains.idea-community


  # Cloud admin
  #oci-cli

  # Shells, remote debugging
  mosh

  # Misc others
  fpm
  #rpmbuild
  #nixops
  #radeontop
  go-md2man
  unrar
  # ---
  # AV and Games
  # ---

  # screen recroding etc
  #vokoscreen

  # Audio
  #pamixer
  #paprefs
  #alsaLib
  #fluidsynth
  #soundfont-fluid
  #jack2
  #jack_rack
  #timemachine
  #audacity
  #samplv1
  # chuck
  #ardour
  #qjackctl
  # bitwig-studio
  #AMB-plugins
  #caps
  #ladspaPlugins
  #zam-plugins

  # Photo Editing
  #gimp
  #blender
  #inkscape
  #krita

  # Bling
  #almonds
  #xaos
  cbonsai
  cmatrix
  nyancat
  peaclock
  pipes

  # Video
  ffmpeg
  mpv
  #gimp
  yt-dlp
  #mplayer
  #spotify
  #(pkgs.mplayer.override { jackaudioSupport = true; })
  #(pkgs.mpv.override { jackaudioSupport = true; })
  #(pkgs.blender.override { jackaudioSupport = true; })

  # Games, GFX Demos etc
  #minetest
  #glxinfo
  gtypist
  #unity3d

  # electronics projects
  #arduino
  #fritzing
  #ino # removed - stuck on python2.7

  # games
  #steam
  #steam-run
  #lutris
  #libGL_driver
  #mesa_drivers
  #mesa.drivers

  # messaging
  #teams

  # audio
  #bluez-tools
  #pulseaudio-modules-bt
  #pulseeffects-legacy
  #strawberry
  #cli-visualizer


  # stores and retrives passwords securely
  #pass

  #fahviewer
  #fahcontrol
  niv

  # random
  #thefuck

]
