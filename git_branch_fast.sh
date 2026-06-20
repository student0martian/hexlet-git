__git_branch_fast() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    
    if [ -n "$branch" ]; then
        # Цветовые коды для printf: 32 - зеленый, 31 - красный
        local color="\033[32m"
        local dirty=""
        
        if ! git diff --quiet 2>/dev/null; then
            color="\033[31m"
            dirty="*"
        fi
        
        # Выводим красивую чистую строку с цветом
        printf " (${color}%s%s\033[0m)" "$branch" "$dirty"
    fi
}

