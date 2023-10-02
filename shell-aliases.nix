{
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
  search = ''nix --extra-experimental-features "nix-command flakes" search nixpkgs'';
}
