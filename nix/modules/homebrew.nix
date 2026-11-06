{...}: {
  homebrew = {
    enable = true;
    taps = ["anomalyco/tap"];
    brews = [
      {
        name = "devvmhq/tap/devvm";
        trusted = true;
      }
      "hunk"
      "lima"
      "mas"
      "mole"
      "openssl@4"
      "vite-plus"
    ];

    # Ownership rule:
    # - Nix owns CLI/dev tooling and open fonts, except devvm and Hunk (Homebrew)
    # - Homebrew owns GUI/macOS apps + proprietary font exceptions
    casks = [
      # GUI/macOS apps
      "adobe-creative-cloud"
      "anomalyco/tap/hex"
      "blender"
      "brave-origin@nightly"
      "docker-desktop"
      "figma"
      "ghostty"
      "handbrake-app"
      "mos"
      "obsidian"
      "proton-drive"
      "protonvpn"
      "raycast"
      "sf-symbols"
      "slack"
      "status-trio"
      "tailscale-app"
      "utm"

      # Font exceptions kept in Homebrew (not managed by nixpkgs)
      "font-sf-mono"
      "font-sf-pro"
    ];

    masApps = {
      # "Yoink" = 457622435;
      # "PDFgear" = 6469021132;
    };

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
