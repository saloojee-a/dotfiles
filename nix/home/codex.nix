{config, ...}: let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  liveLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.file = {
    ".codex/config.toml" = {
      source = liveLink ".codex/config.toml";
      force = true;
    };
    ".codex/AGENTS.md" = {
      source = liveLink ".pi/agent/AGENTS.md";
      force = true;
    };
  };
}
