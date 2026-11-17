{
  description = "Dendritic Hyprland Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    wrappers.url = "github:nix-community/nix-wrapper-modules";
  };

  outputs =
    {
      nixpkgs,
      wrappers,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      runtimePkgsDefault = {
        inherit (pkgs)
          hyprpaper
          hyprlock
          hypridle
          hyprshot
          hyprpolkitagent
          brightnessctl
          playerctl
          ;
      };
      mkWrapper =
        {
          pkgs,
          package,
          runtimePkgs ? { },
          env,
          flags,
        }:
        (wrappers.lib.wrapPackage (
          { ... }: {
            inherit
              pkgs
              package
              env
              flags
              ;

            runtimePkgs = builtins.attrValues (runtimePkgsDefault // runtimePkgs);
          }
        ));
    in
    {
      packages.${system} = {
        default = pkgs.lib.makeOverridable mkWrapper {
          inherit pkgs;
          package = pkgs.hyprland;
          env."HYPRLAND_ROOT" = ./.;
          flags."--config" = ./hyprland.lua;
        };
      };
    };
}
