let
  pkgs = import <nixpkgs> {};

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
