{
  lib,
  pkgs,
  ...
}: let
  # Share the generated Tokyo Night palette with Neovim and Rex.
  colors = builtins.fromJSON (builtins.readFile ../../.config/nvim/tokyonight-night.json);
  theme = with colors; {
    separator = fg_gutter;
    header = {fg = blue; attr = "b";};
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
    search_result = {fg = fg; bg = bg_search;};
    shape_binary = orange;
    shape_block = blue;
    shape_bool = orange;
    shape_closure = blue;
    shape_custom = blue;
    shape_datetime = cyan;
    shape_directory = cyan;
    shape_external = blue;
    shape_external_resolved = blue;
    shape_externalarg = fg;
    shape_filepath = cyan;
    shape_flag = blue5;
    shape_float = orange;
    shape_garbage = {fg = red; attr = "b";};
    shape_glob_interpolation = cyan;
    shape_globpattern = cyan;
    shape_int = orange;
    shape_internalcall = {fg = blue; attr = "b";};
    shape_keyword = {fg = magenta; attr = "bi";};
    shape_list = fg;
    shape_literal = orange;
    shape_match_pattern = green;
    shape_matching_brackets = {fg = orange; attr = "b";};
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

    # Recolor Nu's built-in prompt without changing its text or formatting.
    let prompt_colors = {|text|
      $text
      | str replace --all (ansi green_bold) (ansi {fg: '${colors.blue}' attr: b})
      | str replace --all (ansi light_green_bold) (ansi {fg: '${colors.blue}' attr: b})
      | str replace --all (ansi red_bold) (ansi {fg: '${colors.red}' attr: b})
      | str replace --all (ansi light_red_bold) (ansi {fg: '${colors.red}' attr: b})
      | str replace --all (ansi magenta) (ansi {fg: '${colors.magenta}'})
      | str replace --all (ansi green) (ansi {fg: '${colors.dark5}'})
      | str replace --all (ansi magenta_underline) (ansi {fg: '${colors.magenta}' attr: u})
    }
    # default_prompt and repository-prompt come from config.nu above.
    $env.PROMPT_COMMAND = {||
      let directory = (do $prompt_colors (do $default_prompt))
      let repository = (repository-prompt)
      if (config use-colors) {
        let repository_color = (ansi {fg: '${colors.dark5}'})
        $'($directory)($repository_color)($repository)(ansi reset)'
      } else {
        $'($directory)($repository)'
      }
    }
    let default_right_prompt = $env.PROMPT_COMMAND_RIGHT
    $env.PROMPT_COMMAND_RIGHT = {|| do $prompt_colors (do $default_right_prompt) }
  '';
  extraEnv = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
    # Homebrew's shell initialization does not run in Nushell.
    $env.PATH = ($env.PATH | prepend ['/opt/homebrew/bin' '/opt/homebrew/sbin'] | uniq)
    $env.PATH = ($env.PATH | prepend '/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS' | uniq)
  '';
}
