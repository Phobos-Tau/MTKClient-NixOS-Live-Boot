{
  description = "MTKClient";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:

    let
      lib = nixpkgs.lib;
      pkgsUnstableFor = system: import nixpkgs-unstable { inherit system; };
    in {
      nixosConfigurations = {
        "mtkclient_x86-64" = 
        let
          system = "x86_64-linux";
          pkgs-unstable = pkgsUnstableFor system;
        in 
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
    
          modules = [
            ({ modulesPath, ... }: {
              nixpkgs.hostPlatform = system;
            })
            ./configuration.nix
          
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "mv -f \"$1\" \"$1.$(date +%s).bak\"";
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
                users.mtkclient = { pkgs, ... }: {
                  home = {
                    username = "mtkclient";
                    homeDirectory = "/home/mtkclient";
                    stateVersion = "25.11";
                  };
                };
              };
            }
          ];
        };
        mtkclient_aarch64 = 
        let
          system = "aarch64-linux";
          pkgs-unstable = pkgsUnstableFor system;
        in
        lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };

          modules = [
            ({ modulesPath, ... }: {
              nixpkgs.hostPlatform = system;
            })
            ./configuration.nix
          
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "mv -f \"$1\" \"$1.$(date +%s).bak\"";
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
                users.mtkclient = { pkgs, ... }: {
                  home = {
                    username = "mtkclient";
                    homeDirectory = "/home/mtkclient";
                    stateVersion = "25.11";
                  };
                };
              };
            }
          ];
        };
      };
    };
}


