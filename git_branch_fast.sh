__git_branch_fast() {
    # Ищем каталог .git вверх по дереву папок
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ]; then
            local git_dir="$dir/.git"
            break
        elif [ -f "$dir/.git" ]; then
            # Поддержка git-worktrees или субмодулей
            local git_dir
            git_dir=$(git rev-parse --git-dir 2>/dev/null)
            break
        fi
        dir="${dir%/*}"
    done

    # Если мы не в git-репозитории — выходим
    [ -n "$git_dir" ] || return

    # Читаем HEAD напрямую без вызова git (для скорости)
    local head
    if [ -f "$git_dir/HEAD" ]; then
        head=$(<"$git_dir/HEAD")
    else
        return
    fi

    # Определяем имя ветки
    local branch
    case "$head" in
        "ref: refs/heads/"*)
            branch="${head#ref: refs/heads/}"
            ;;
        "ref: "*)
            branch="${head##*/}"
            ;;
        *)
            branch="${head:0:7}" # detached HEAD
            ;;
    esac

    # Быстрая проверка изменений (dirty state)
    local dirty=""
    # Проверяем, менялся ли индекс или файлы позже, чем HEAD
    if [ -f "$git_dir/index" ] && [ "$git_dir/index" -nt "$git_dir/HEAD" ]; then
        dirty="*"
    fi

    # Выводим результат в скобках для читаемости
    printf " (%s%s)" "$branch" "$dirty"
}
