{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fluidlite.url = "github:exit91/FluidLite";
  };

  outputs =
    inputs:
    let
      eachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
      pkgsFor = eachSystem (system: inputs.nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (system: {
        default = pkgsFor.${system}.mkShell {
          nativeBuildInputs = with pkgsFor.${system}; [
            pkg-config
            clang
          ];
          buildInputs = with pkgsFor.${system}; [
            inputs.fluidlite.packages.${system}.default
            alsa-lib
            atk
            cairo
            gdk-pixbuf
            glib
            glibc
            gtk3
            libclang
            libsoup_3
            pango
            webkitgtk_4_1
            xdotool
          ];
          LIBCLANG_PATH = "${pkgsFor.${system}.libclang.lib}/lib";
        };
      });

      packages = eachSystem (system: {
        default = pkgsFor.${system}.callPackage ./package.nix {
          fluidlite = inputs.fluidlite.packages.${system}.default;
        };
      });
    };
}
