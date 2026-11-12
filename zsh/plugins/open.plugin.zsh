# ---------- Open function (with fzf & -w selector support) ----------
unalias open 2>/dev/null

_find_cmd() {
    local name="$1"
    if command -v "$name" &>/dev/null; then
        echo "$name"
        return 0
    fi

    local dir match
    for dir in ${(s/:/)PATH}; do
        [ -d "$dir" ] || continue
        match=$(find "$dir" -maxdepth 1 \( -type f -o -type l \) -iname "$name" -executable 2>/dev/null | head -n1)
        if [ -n "$match" ]; then
            basename "$match"
            return 0
        fi
    done
    return 1
}

open() {
    local depth=1
    local show_all=false
    local choose_app=false
    local force_all_apps=false
    local app=""
    local target=""
    local files=""
    local preview_cmd="cat {}"
    local selected=""

    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                echo -e "\033[1;34mUsage: open [OPTIONS] [FILE]\033[0m"
                echo ""
                echo "Options:"
                echo "  -a, --all         Show hidden files"
                echo "  -c, --choose      Choose app filtering by MIME type"
                echo "  -call, --all-apps Choose from ALL installed apps"
                echo "  -w, --with APP    Open target (or fzf selection) with a specific app"
                echo "  -[1-9]            Search depth (e.g. open -2)"
                echo "  -h, --help        Show this help message"
                return 0
                ;;
            -a|--all)
                show_all=true
                shift
                ;;
            -c|--choose)
                choose_app=true
                shift
                ;;
            -call|--all-apps)
                force_all_apps=true
                shift
                ;;
            -w|--with)
                if [ -z "$2" ] || [[ "$2" == -* ]]; then
                    echo -e "\033[31m❌ Error: The -w option requires an application name.\033[0m"
                    echo -e "\033[33mExample: open -w vlc or open -w firefox index.html\033[0m"
                    return 1
                fi
                app="$2"
                shift 2
                ;;
            -[0-9]*)
                depth="${1#-}"
                shift
                ;;
            *)
                target="$1"
                shift
                ;;
        esac
    done

    _open_file_safely() {
        local file_list="$1"

        # 1) تطبيق محدد بواسطة -w
        if [ -n "$app" ]; then
            local -a app_words
            app_words=( ${(z)app} )
            local app_cmd="${app_words[1]}"
            local app_args="${app_words[2,-1]}"
            local real_cmd

            real_cmd=$(_find_cmd "$app_cmd")
            if [ -z "$real_cmd" ]; then
                echo -e "\033[31m❌ Command '$app_cmd' not found. Check the name.\033[0m"
                return 1
            fi

            echo "$file_list" | while IFS= read -r f; do
                [ -n "$f" ] && setsid ${=real_cmd} ${=app_args} "$f" >/dev/null 2>&1 &!
            done
            return 0
        fi

        local -a dirs
        dirs=(
            /usr/share/applications
            /usr/local/share/applications
            "$HOME/.local/share/applications"
            /var/lib/flatpak/exports/share/applications
            "$HOME/.local/share/flatpak/exports/share/applications"
        )

        # 2) اختيار التطبيقات (-c أو -call)
        if [ "$choose_app" = true ] || [ "$force_all_apps" = true ]; then
            local desktop_files chosen exec_cmd desktop_path

            if [ "$force_all_apps" = false ]; then
                local mimes
                mimes=$(echo "$file_list" | while IFS= read -r f; do
                    [ -n "$f" ] && xdg-mime query filetype "$f" 2>/dev/null
                done | sort -u)

                desktop_files=$(echo "$mimes" | while IFS= read -r m; do
                    [ -n "$m" ] && find "${dirs[@]}" -maxdepth 1 -name '*.desktop' 2>/dev/null | xargs grep -lF "$m" 2>/dev/null
                done | sort -u)
            fi

            if [ -z "$desktop_files" ]; then
                desktop_files=$(find "${dirs[@]}" -maxdepth 1 -name '*.desktop' 2>/dev/null)
            fi

            if [ -z "$desktop_files" ]; then
                echo -e "\033[33m⚠️ No applications found on your system.\033[0m"
                return 1
            fi

            chosen=$(echo "$desktop_files" | while IFS= read -r fx; do
                if grep -qi "^NoDisplay=true" "$fx" 2>/dev/null || grep -qi "^Terminal=true" "$fx" 2>/dev/null; then
                    continue
                fi
                name=$(grep -m1 '^Name=' "$fx" | cut -d= -f2)
                [ -n "$name" ] && echo "$name|$fx"
            done | sort -t'|' -k1,1 -u | fzf --delimiter='|' --with-nth=1 \
                --prompt="Apps > " --height 50% --border \
                --preview='grep -E "^(Name|Exec|Comment)=" {2}' \
                --preview-window=right:40%:wrap)

            [ -z "$chosen" ] && return 0

            desktop_path="${chosen#*|}"

            echo "$file_list" | while IFS= read -r f; do
                [ -z "$f" ] && continue
                if command -v gio &>/dev/null; then
                    setsid gio launch "$desktop_path" "$f" >/dev/null 2>&1 &!
                else
                    exec_cmd=$(grep -m1 '^Exec=' "$desktop_path" | cut -d= -f2- | sed 's/ *%[a-zA-Z]//g')
                    setsid sh -c "$exec_cmd \"$f\"" >/dev/null 2>&1 &!
                fi
            done
            return 0
        fi

        # 3) الفتح الافتراضي
        echo "$file_list" | while IFS= read -r f; do
            [ -n "$f" ] && xdg-open "$f" >/dev/null 2>&1 &!
        done
    }

    # إذا تم تحديد ملف مباشر مع الأمر، افتحه فوراً
    if [ -n "$target" ]; then
        _open_file_safely "$target"
        return 0
    fi

    # إذا لم يُحدد ملف، استخدم fd لتوليد القائمة لـ fzf
    local fd_bin=""
    if command -v fd &>/dev/null; then
        fd_bin="fd"
    elif command -v fdfind &>/dev/null; then
        fd_bin="fdfind"
    fi

    if [ -n "$fd_bin" ]; then
        local fd_opts=(--max-depth "$depth" --type f)
        [ "$show_all" = true ] && fd_opts+=(--hidden)
        files=$($fd_bin "${fd_opts[@]}" . 2>/dev/null)
    else
        if [ "$show_all" = true ]; then
            files=$(find . -maxdepth "$depth" -type f 2>/dev/null)
        else
            files=$(find . -maxdepth "$depth" -type f ! -path "*/.*" 2>/dev/null)
        fi
    fi

    if [ -z "$files" ]; then
        echo -e "\033[31m⚠️ No files found in this directory (Depth: $depth).\033[0m"
        return 1
    fi

    if command -v bat &> /dev/null; then
        preview_cmd="bat --style=numbers --color=always --line-range :500 {}"
    fi

    local prompt_msg="Open > "
    [ -n "$app" ] && prompt_msg="Open with ($app) > "

    selected=$(echo "$files" | fzf -m --preview "$preview_cmd" --height 70% --border --prompt="$prompt_msg")

    if [ -n "$selected" ]; then
        _open_file_safely "$selected"
    fi
}
