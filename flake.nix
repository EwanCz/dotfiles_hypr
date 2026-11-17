{
  description = "Dendritic Hyprland Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    wrappers.url = "github:nix-community/nix-wrapper-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
    }@inputs:
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
          env ? { },
          flags ? { },
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
            passthru.providedSessions = package.providedSessions or [ ];
          }
        ));

      # Give each of these its own baked-in --config so they work the same
      # way whether they're launched from inside Hyprland or anywhere else.
      hyprlock = pkgs.lib.makeOverridable mkWrapper {
        inherit pkgs;
        package = pkgs.hyprlock;
        flags."--config" = ./hyprlock.conf;
      };
      hypridle = pkgs.lib.makeOverridable mkWrapper {
        inherit pkgs;
        package = pkgs.hypridle;
        flags."--config" = ./hypridle.conf;
      };
      hyprpaper = pkgs.lib.makeOverridable mkWrapper {
        inherit pkgs;
        package = pkgs.hyprpaper;
        flags."--config" = ./hyprpaper.conf;
      };
    in
    {
      packages.${system} = {
        inherit hyprlock hypridle hyprpaper;

        default = pkgs.lib.makeOverridable mkWrapper {
          inherit pkgs;
          package = pkgs.hyprland;
          env."HYPRLAND_ROOT" = ./.;
          flags."--config" = ./hyprland.lua;
          runtimePkgs = {
            inherit hyprlock hypridle hyprpaper;
          };
        };
      };
    };
}
