{
  inputs,
  homeDirectory,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./packages.nix
    ./rust.nix
  ];

  environment.etc."codex/config.toml".source = ../config/codex.toml;
  environment.shells = [pkgs.nushell];

  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };

  home-manager = {
    extraSpecialArgs = {inherit homeDirectory username;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../home.nix;
  };
}
