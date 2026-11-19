{
  lib,
  pkgs,
  ...
}: let
  # Share the generated Tokyo Night palette with Neovim and Rex.
  colors = builtins.fromJSON (builtins.readFile ../../.config/nvim/tokyonight-night.json);
  theme = with colors; {
    separator = fg_gutter;
    header = blue;
    row_index = dark5;
    hints = comment;
    empty = dark5;
    bool = orange;
    int = orange;
    float = orange;
    filesize = cyan;
    duration = yellow;
    datetime = cyan;
    range = cyan;
    string = green;
    glob = cyan;
    nothing = dark5;
    binary = orange;
    cell-path = fg;
    record = fg;
    list = fg;
    block = blue;
    closure = blue;
    semver = cyan;
    semver-range = cyan;
    binary_null_char = comment;
    binary_printable = cyan;
    binary_ascii_other = magenta;
    binary_non_ascii = orange;
    binary_whitespace = green;
    search_result = {
      fg = fg;
      bg = bg_search;
    };
    shape_binary = orange;
    shape_block = blue;
    shape_bool = orange;
    shape_closure = blue;
    shape_custom = blue;
    shape_datetime = cyan;
    shape_directory = cyan;
    # With external resolution enabled, this is the unresolved command name.
    shape_external = {
      fg = red;
      attr = "b";
    };
    shape_external_resolved = green;
    shape_externalarg = fg;
    shape_filepath = cyan;
    shape_flag = blue5;
    shape_float = orange;
    shape_garbage = red;
    shape_glob_interpolation = cyan;
    shape_globpattern = cyan;
    shape_int = orange;
    shape_internalcall = green;
    shape_keyword = {
      fg = magenta;
      attr = "i";
    };
    shape_list = fg;
    shape_literal = orange;
    shape_match_pattern = green;
    shape_matching_brackets = orange;
    shape_nothing = dark5;
    shape_operator = blue5;
    shape_pipe = blue5;
    shape_range = blue5;
    shape_raw_string = green;
    shape_record = fg;
    shape_redirection = blue5;
    shape_signature = blue;
    shape_string = green;
    shape_string_interpolation = cyan;
    shape_table = blue;
    shape_vardecl = magenta;
    shape_variable = fg;
  };
in {
  enable = true;
  loadSessionVariables = true;
  configFile.source = ./nushell/config.nu;
  envFile.source = ./nushell/env.nu;
  extraConfig = ''
    $env.config.color_config = ($env.config.color_config | merge ('${builtins.toJSON theme}' | from json))
    $env.config.highlight_resolved_externals = true

    # Keep Nu's path formatting; use blue for the path and muted slate for metadata.
    # default_prompt and repository-prompt come from config.nu above.
    $env.PROMPT_COMMAND = {||
      let directory = (do $default_prompt)
      let repository = (repository-prompt)
      if (config use-colors) {
        let path = ($directory
          | str replace --all (ansi green_bold) (ansi {fg: '${colors.blue}'})
          | str replace --all (ansi light_green_bold) (ansi {fg: '${colors.blue}'})
          | str replace --all (ansi red_bold) (ansi {fg: '${colors.red}'})
          | str replace --all (ansi light_red_bold) (ansi {fg: '${colors.red}'}))
        $'($path)(ansi {fg: "${colors.dark5}"})($repository)(ansi reset)'
      } else {
        $'($directory | ansi strip)($repository)'
      }
    }

    let default_indicator = ($env.PROMPT_INDICATOR? | default '> ')
    $env.PROMPT_INDICATOR = {||
      if (config use-colors) {
        $'(ansi {fg: "${colors.blue}"})($default_indicator)(ansi reset)'
      } else {
        $default_indicator
      }
    }

    $env.PROMPT_COMMAND_RIGHT = {||
      let time = (date now | format date '%a %b %d %H:%M:%S %Y')
      let exit_code = ($env.LAST_EXIT_CODE? | default 0)
      let failure = if $exit_code == 0 {
        ""
      } else if (config use-colors) {
        $'(ansi {fg: "${colors.red}"})($exit_code)'
      } else {
        $'($exit_code)'
      }
      if (config use-colors) {
        $'($failure) (ansi {fg: "${colors.dark5}"})($time)(ansi reset)'
      } else {
        $'($failure) ($time)'
      }
    }

    # Enable fzf's Ctrl+T file picker without changing history or directory shortcuts.
    $env.FZF_CTRL_R_COMMAND = ""
    $env.FZF_ALT_C_COMMAND = ""
    source "${pkgs.fzf}/share/fzf/key-bindings.nu"
  '';
  extraEnv = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
    # Homebrew's shell initialization does not run in Nushell.
    $env.PATH = ($env.PATH | prepend ['/opt/homebrew/bin' '/opt/homebrew/sbin'] | uniq)
    $env.PATH = ($env.PATH | prepend '/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS' | uniq)
  '';
}
