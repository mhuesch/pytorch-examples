{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        devShells = {
          default =
            let pkgs = import nixpkgs { inherit system; };
            in
            pkgs.mkShell {
              shellHook = ''
                export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                  pkgs.stdenv.cc.cc
                  pkgs.zlib
                ]}
              '';
              buildInputs = with pkgs; [
                # setup stuff
                zlib
                stdenv.cc.cc.lib

                # python
                (python311.withPackages(ps: []))
                python311Packages.pip
              ];
            };
        };
      });
}
