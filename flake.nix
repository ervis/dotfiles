{
  description = "Personal dotfiles and development environment with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHomeConfig = username: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          { home.username = username; }
          ./home.nix
        ];
      };
    in
    {
      homeConfigurations."ez@zbox" = mkHomeConfig "ez";

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs
          # Add more tools here as needed
        ];
      };
    };
}
