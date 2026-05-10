{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #add grub themes to input
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    # minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
  };

  nixConfig.extra-substituters = [
    "https://cache.nixos-cuda.org"
  ];

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/configuration.nix
        ./modules/nvidia.nix
        ./modules/grub.nix
        #swap gnome if needed
        ./modules/kde.nix
        ./modules/swap.nix
        ./modules/gns3.nix
        inputs.home-manager.nixosModules.default
        inputs.minegrub-theme.nixosModules.default
        #inputs.minegrub-world-sel-theme.nixosModules.default
      ];
    };
  };
}
