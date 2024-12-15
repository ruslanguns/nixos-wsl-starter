{ inputs, username, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    validateSopsFiles = false;

    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      "users/${username}/password".neededForUsers = true;
      "users/${username}/ssh_private_key" = {
        owner = username.name;
        inherit (username) group;
        path = "/home/${username}/.ssh/id_ed25519";
      };
    };
  };
}
