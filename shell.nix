{ pkgs ? import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2021-02-12";
  url = "https://github.com/nixos/nixpkgs/";
  # Commit hash for nixos-unstable as of 2018-09-12
  # `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  ref = "refs/heads/nixos-unstable";
  rev = "758b29b5a28b818e311ad540637a5c1e40867489";
}) { } }:

with pkgs;

let
  inherit (lib) optional optionals;
  elixir = nur.repos.beam.pkg.v23_0.elixir.v1_11_0;
in mkShell {
  buildInputs = [ elixir git ]
    ++ optional stdenv.isLinux libnotify # For ExUnit Notifier on Linux.
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optional stdenv.isDarwin
    terminal-notifier # For ExUnit Notifier on macOS.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);
}
