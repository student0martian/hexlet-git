# Быстрое определение ветки и dirty-state без git-prompt
__git_branch_fast() {
    # Проверяем, есть ли .git
    [ -d .git ] || return

    # Читаем HEAD
    local head
    head=$(<.git/HEAD 2>/dev/null) || return

    # Определяем ветку или SHA
    local branch
    case "$head" in
        ref:*)
            branch="${head##*/}"
            ;;
        *)
            branch="${head:0:7}"   # detached HEAD
            ;;
    esac

    # Проверяем dirty-state (быстро!)
    # Если есть изменения — добавляем "*"
    local dirty=""
    if [ -n "$(ls -A .git/refs/stash 2>/dev/null)" ] || \
       [ -n "$(find . -maxdepth 1 -type f -newer .git/HEAD 2>/dev/null)" ]; then
        dirty="*"
    fi

    printf "%s%s" "$branch" "$dirty"
}

