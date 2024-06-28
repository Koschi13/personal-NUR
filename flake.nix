{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          packagesFn =
            pkgs:
            import ./default.nix {
              inherit pkgs;
              inherit (pkgs) lib buildGoModule fetchFromGitHub fetchurl installShellFiles;
            };
        in
        {
          packages = packagesFn pkgs;
          overlays.default = _: packagesFn;

          formatter = pkgs.nixpkgs-fmt;
        }
      );
}
