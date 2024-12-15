{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jeezyvim.url = "github:LGUG2Z/JeezyVim";
  };

  outputs = { self, nixpkgs, home-manager, nur, nixpkgs-unstable, nix-index-database, ... } @ inputs:
    let
      inherit (self) outputs;

      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      systems = [
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      nixpkgsWithOverlays = system: import nixpkgs {
        inherit system config;

        overlays = [
          nur.overlay
          inputs.jeezyvim.overlays.default
          (_final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system config;
            };
          })
        ];
      };

      configurationDefaults = args: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = {
        inherit secrets inputs self nix-index-database;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration =
        { system ? "x86_64-linux"
        , hostname
        , username
        , args ? { }
        , modules
        ,
        }:
        let
          specialArgs = argDefaults // { inherit hostname username; } // args;
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          pkgs = nixpkgsWithOverlays system;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ] ++ modules;
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      nixosConfigurations = {
        "desktop-wsl-01" = mkNixosConfiguration {
          hostname = "desktop-wsl-01";
          username = "rus";
          modules = [
            inputs.nixos-wsl.nixosModules.wsl
            ./wsl.nix
          ];
        };

        "desktop-wsl-02" = mkNixosConfiguration {
          hostname = "desktop-wsl-02";
          username = "rus";
          modules = [
            inputs.nixos-wsl.nixosModules.wsl
            ./wsl.nix
          ];
        };
      };
    };
}
