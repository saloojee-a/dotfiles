# Home Manager loads the shared session variables and PATH before this file.
$env.PATH = (
    $env.PATH
    | where {|entry| $entry != ($env.HOME | path join '.local/share/vite-plus/bin') and $entry != ($env.HOME | path join '.local/share/vite-plus/fallback-bin') }
    | prepend ($env.HOME | path join '.local/share/vite-plus/bin')
    | append ($env.HOME | path join '.local/share/vite-plus/fallback-bin')
    | uniq
)
