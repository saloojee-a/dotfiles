$env.config.show_banner = false

# Preserve Nu's built-in left prompt, adding compact repository status.
def repository-prompt [] {
    # Prefer jj in colocated repositories. Snapshot once for current file status.
    let is_jj = (try {
        (^jj root --ignore-working-copy | complete).exit_code == 0
    } catch { false })
    if $is_jj {
        let state = (try {
            ^jj log --no-graph --color never -r @ -T 'change_id.shortest(8) ++ if(!empty, " *") ++ if(conflict, " !")' e> /dev/null | str trim
        } catch { '' })
        if ($state | is-empty) { return '' }
        let outgoing = (try {
            ^jj log --ignore-working-copy --no-graph --color never --limit 1 -r '::@ ~ immutable() ~ ::remote_bookmarks(remote=origin) ~ empty()' -T '" ↑"' e> /dev/null
        } catch { '' })
        return $' [jj ($state)($outgoing)]'
    }

    let branch = (try {
        ^git symbolic-ref --quiet --short HEAD e> /dev/null | str trim
    } catch {
        try { ^git rev-parse --short HEAD e> /dev/null | str trim } catch { '' }
    })
    if ($branch | is-empty) { return '' }

    let entries = (try {
        ^git --no-optional-locks status --porcelain=v1 --untracked-files=normal e> /dev/null
        | lines
        | each {|line| $line | str substring 0..1 }
    } catch { [] })
    let dirty = if ($entries | is-not-empty) { ' *' } else { '' }
    let conflict = if ($entries | any {|entry| $entry in ['DD' 'AU' 'UD' 'UA' 'DU' 'AA' 'UU'] }) { ' !' } else { '' }

    # Prefer the upstream, falling back to the same-name origin branch.
    let upstream = (try {
        ^git rev-parse --verify --symbolic-full-name '@{upstream}' e> /dev/null | str trim
    } catch {
        try { ^git rev-parse --verify --symbolic-full-name $'refs/remotes/origin/($branch)' e> /dev/null | str trim } catch { '' }
    })
    let counts = if ($upstream | is-not-empty) {
        try {
            ^git rev-list --left-right --count $'HEAD...($upstream)' e> /dev/null
            | split words
            | into int
        } catch { [0 0] }
    } else { [0 0] }
    let divergence = match [($counts.0 > 0) ($counts.1 > 0)] {
        [true true] => ' ↕'
        [true false] => ' ↑'
        [false true] => ' ↓'
        _ => ''
    }
    $' [git ($branch)($dirty)($conflict)($divergence)]'
}

let default_prompt = $env.PROMPT_COMMAND
$env.PROMPT_COMMAND = {|| $'((do $default_prompt))(repository-prompt)' }

$env.PROMPT_COMMAND_RIGHT = {||
    let colors = if (config use-colors) {
        {date: (ansi magenta), separator: (ansi green), fail: (ansi red_bold)}
    } else {
        {date: '', separator: '', fail: ''}
    }
    let time = (date now | format date '%a %b %d %H:%M:%S %Y'
        | str replace --all ':' $'($colors.separator):($colors.date)')
    let exit_code = ($env.LAST_EXIT_CODE? | default 0)
    let failure = if $exit_code != 0 {
        $'($colors.fail)($exit_code)'
    } else { '' }
    $'($failure) (ansi reset)($colors.date)($time)(ansi reset)'
}

alias hd = hunk diff
alias rebuild = sudo -i darwin-rebuild switch --flake ~/dotfiles/nix#mac
alias v = nvim
