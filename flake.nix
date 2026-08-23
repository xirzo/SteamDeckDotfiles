{
  description = "Steam Deck Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-filter.follows = "";
      inputs.libnbtplusplus.follows = "";
    };
  };

  outputs = { self, nixpkgs, home-manager, jovian, freesmlauncher, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        jovian.nixosModules.default
        ./system/configuration.nix
        {
          nixpkgs.overlays = [ freesmlauncher.overlays.default ];
        }
      ];
    };

    homeConfigurations."xir" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home/home.nix ];
    };
  };
}
