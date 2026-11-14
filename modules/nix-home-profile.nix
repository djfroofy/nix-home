{ lib, ... }:

with lib;

{
  options.nixHome.profile = {
    identity = {
      username = mkOption {
        type = types.str;
        description = "Local account username for this Home Manager configuration.";
      };

      fullName = mkOption {
        type = types.str;
        description = "Human-readable full name used for Git and related tools.";
      };

      email = mkOption {
        type = types.str;
        description = "Primary email address for Git and related tools.";
      };

      homeDirectory = mkOption {
        type = types.str;
        description = "Absolute home directory path for the configured user.";
      };

      gitSigningKey = mkOption {
        type = types.str;
        description = "Git signing key fingerprint or key ID.";
      };
    };

    linux = {
      wifiInterface = mkOption {
        type = types.str;
        default = "";
        description = "Wireless interface for Xmobar; empty on hosts without Wi-Fi.";
      };
      cpuTemperature = mkOption {
        type = types.bool;
        default = true;
        description = "Include the multicore temperature display (disable on unsupported CPUs).";
      };
    };

  };
}
