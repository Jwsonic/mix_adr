{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  inherit (lib) optional optionals;
  elixir = beam.packages.erlangR23.elixir.override {
    version = "1.11.3";
    sha256 = "sha256-DqmKpMLxrXn23fsX/hrjDsYCmhD5jbVtvOX8EwKBakc=";
  };
in mkShell {
  buildInputs = [ elixir git ]
    ++ optional pkgs.stdenv.isLinux libnotify # For ExUnit Notifier on Linux.
    ++ optional pkgs.stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optional pkgs.stdenv.isDarwin
    terminal-notifier # For ExUnit Notifier on macOS.
    ++ optionals pkgs.stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);
}
