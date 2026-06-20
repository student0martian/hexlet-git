__git_branch_fast() {
    local branch
    # Безопасно берем имя ветки или хэш коммита без циклов
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    if [ -n "$branch" ]; then
        local dirty=""
        # Быстрая проверка изменений, не вешающая систему
        git diff --quiet 2>/dev/null || dirty="*"
        printf " (%s%s)" "$branch" "$dirty"
    fi
}

