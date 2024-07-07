{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          neovim-overlay
        ];
      };
    in {
      packages = rec {
        default = neovim;
        neovim = pkgs.neovim;
      };
      formatter = pkgs.alejandra;
    })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
