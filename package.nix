{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
  atk,
  cairo,
  clang,
  fluidlite,
  gdk-pixbuf,
  glib,
  glibc,
  gtk3,
  libclang,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  xdotool,
}:
rustPlatform.buildRustPackage {
  pname = "chordflow";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
      lib.fileset.unions [
        ./chordflow_audio
        ./chordflow_desktop
        ./chordflow_music_theory
        ./chordflow_shared
        ./chordflow_tui
        ./Cargo.toml
        ./Cargo.lock
        ./Cross.toml
      ]
    );
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zhfKcY6L0jOJia6HGWobTroG+Er4PIJtNFx+vh4XBks=";

  cmakeBuildType = "Production";

  LIBCLANG_PATH = "${libclang.lib}/lib";

  nativeBuildInputs = [
    pkg-config
    clang
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    fluidlite
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

  meta = with lib; {
    description = "TUI tool providing dynamic chord progressions with a built-in metronome";
    longDescription = "ChordFlow is a TUI (Terminal User Interface) tool designed to help guitarists/musicians practice improvisation and master the guitar neck by providing dynamic chord progressions with a built-in metronome.";
    license = licenses.mit;
  };
}
