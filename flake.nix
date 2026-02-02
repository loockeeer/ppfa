{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.11";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = system; };
      ocaml = pkgs.ocaml.override { flambdaSupport = true; };
      opkgs = pkgs.ocaml-ng.mkOcamlPackages ocaml;
      libs = [
        ocaml
        pkgs.dune_3
        opkgs.findlib
        pkgs.ocamlformat

        # GFX_SDL module's libraries
        opkgs.tsdl
        opkgs.tsdl-image
        opkgs.tsdl-ttf

        # GFX_JSOO module's libraries
        opkgs.js_of_ocaml
        opkgs.js_of_ocaml-ppx
      ];
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        packages = libs ++ [ pkgs.simple-http-server ];
        shellHook = ''
          simple-http-server -i -p 2131 . &> /dev/null &
          echo "Static server at http://localhost:2131 !"
        '';
      };
    };
}
