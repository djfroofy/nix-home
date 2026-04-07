{ ... }:
{
  nixHome.profile = {
    identity = {
      username = "your-username";
      fullName = "Your Name";
      email = "you@example.com";
      homeDirectory = "/Users/your-username";
      gitSigningKey = "YOUR_GIT_SIGNING_KEY";
    };

    work = {
      ociProfileName = "your-oci-profile";
      ociCompartmentRoot = "ocid1.compartment.oc1..replace-me";
      ociCompartmentDev = "ocid1.compartment.oc1..replace-me";
    };
  };
}
