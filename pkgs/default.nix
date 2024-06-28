{ pkgs
, lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, installShellFiles
,
}:
let
  callPackage = pkg: pkgs.callPackage pkg;
in
{
  cloudfoundry-cli = callPackage ./cloudfoundry-cli { };
}
