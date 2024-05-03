{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [nodejs_22 nodePackages.pnpm];

        shellHook = ''
          echo "node `${pkgs.nodejs_22}/bin/node --version`"
          echo "pnpm `${pkgs.nodePackages.pnpm}/bin/pnpm --version`"
        '';
      };
    });
}
