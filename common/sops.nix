{ inputs, username, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
    };

    secrets = {
      "login_passwords.${username}".neededForUsers = true;
    };
  };
}
