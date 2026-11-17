# Tokyo Night Night: shared OKLCH palette

Edit **`tokyonight-night.oklch.json`**, then run `just palette` from the repo root.
This is the only hand-maintained color palette for Rex, Nushell, and Neovim.
`@name` / `@nested.name` aliases share colors rather than duplicating values.

The baseline is [Tokyo Night Night](https://github.com/folke/tokyonight.nvim),
version 4.14.1, at the revision recorded in the source file. Its full resolved
palette is captured, including diff/git backgrounds and bright terminal colors.
The existing Neovim `normal` sidebar/float backgrounds are preserved. OKLCH L/C
retain six decimal places so conversion reproduces every original 8-bit RGB
color exactly. This is a faithful conversion, not a palette redesign.

## Generated outputs

- `.config/nvim/tokyonight-night.json`: shared RGB palette. Neovim reads it at
  theme load; `nix/home/nushell.nix` reads the same file during Nix evaluation.
- `themes/generated/Tokyo Night Night OKLCH`: Ghostty-format theme for Rex,
  including ANSI slots 0–15, background, foreground, cursor, and selection.
  Slots 16–255 retain the standard terminal defaults.

Keep generated files in version control. Do not edit them directly. Generation
uses Python's standard library (Python 3.10+), with no packages to install.
Out-of-sRGB colors are gamut-mapped by reducing chroma while preserving OKLCH
lightness and hue. Output is deliberately sRGB for cross-app consistency.

```sh
just palette
just palette-check
```

The check covers reference conversions, gamut mapping, aliases, invalid input,
and consistency between the source and both generated files. `just check` also
runs it.

## Applying updates

### Neovim

The existing stow-managed `~/.config/nvim` link exposes the generated JSON.
Restart Neovim, or run `:colorscheme tokyonight-night` in an existing instance.
Tokyo Night still supplies syntax/plugin highlight rules; `on_colors` replaces
its palette with the shared snapshot. Theme caching is disabled so palette edits
are picked up when the colorscheme is reloaded. Existing typography and floating
border/title overrides remain in place.

### Nushell

Run your usual **`just rebuild`** yourself to activate the Nix-managed config.
The agent does not overwrite deployed Nushell files or run a privileged rebuild.
Ensure new files are included in your normal jj/Git working-copy workflow before
using the Git-backed flake; Nix excludes untracked files from Git flake inputs.

Nushell's syntax, table, and prompt colors come from the shared JSON. The native
prompt adds Git/jj status, using `dark5` for legibility. No separate prompt
package is required.

### Rex

Rex keeps its imported theme in app preferences outside this repo. After every
palette regeneration, import again using the supported client action:

```sh
rex client ls --json
rex -C CLIENT_ID do client.theme.import \
  "path=$HOME/dotfiles/themes/generated/Tokyo Night Night OKLCH"
```

Replace `CLIENT_ID` with the intended Rex app client. Importing selects the theme;
it is not a live file link. This is a dark theme, so it belongs to Rex's dark
appearance slot; the light theme is intentionally left alone. Re-import behavior
(such as creating a second custom theme) is managed by Rex.

### Pi and Hunk

No application-specific palette is added. Keep using their terminal-derived
settings. Hunk already has `theme = "terminal"`. If a running TUI caches terminal
colors, restart it after changing the Rex theme.

## Updating upstream

The snapshot intentionally prevents upstream palette changes from silently
making the apps diverge. When updating it, review upstream additions and aliases
in the OKLCH source, regenerate both outputs, and run the checks. Upstream
highlight rules remain supplied by the installed Tokyo Night plugin.
