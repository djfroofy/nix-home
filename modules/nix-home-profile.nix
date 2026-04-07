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

    work = {
      ociProfileName = mkOption {
        type = types.str;
        description = "Default OCI CLI profile used by work shell helpers.";
      };

      ociCompartmentRoot = mkOption {
        type = types.str;
        description = "OCI compartment OCID for the work root compartment.";
      };

      ociCompartmentDev = mkOption {
        type = types.str;
        description = "OCI compartment OCID for the work development compartment.";
      };
    };
  };
}
