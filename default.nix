let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/30d3d79b7d3607d56546dd2a6b49e156ba0ec634.tar.gz";
    sha256 = "0x5j9q1vi00c6kavnjlrwl3yy1xs60c34pkygm49dld2sgws7n0a";
  }) {};

  # Create a derivation which, when built, writes some Nix code to
  # its $out path.
  derivation-to-import = pkgs.writeText "example" ''
    pkgs: {
      ifd-example = pkgs.stdenv.mkDerivation rec {
        name = "hello-2.10-ifd-example";


        src = pkgs.fetchurl {
          url = "mirror://gnu/hello/2.10.tar.gz";
          sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
        };
      };
    }
  '';

  # Import the derivation. This forces `derivation-to-import` to become
  # a string. This is normal behavior for Nix and Nixpkgs. The specific
  # difference here is the evaluation itself requires the result to be
  # built during the evaluation in order to continue evaluating.
  imported-derivation = import derivation-to-import;

  # Treat the imported-derivation variable as if we hadn't just created
  # its Nix expression inside this same evaluation.
  hello-package = (imported-derivation pkgs).ifd-example;
in hello-package
