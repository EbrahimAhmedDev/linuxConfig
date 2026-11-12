# ---------- Yazi (cd into the last directory on exit) ----------
function yazi() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
        cwd="$(cat -- "$tmp")"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    fi
    # restore thin cursor after leaving yazi
    echo -ne "\e[6 q"
}
