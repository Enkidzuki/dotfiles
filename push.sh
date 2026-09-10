#!/bin/bash
set -e

DOTFILES_DIR="$HOME/repos/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$DOTFILES_DIR/configs"

# Проверка, что папка — git-репозиторий
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Ошибка: $DOTFILES_DIR не является git-репозиторием."
    exit 1
fi

echo "=== Копирую конфиги в dotfiles ==="

CONFIGS=(
    "hypr"
    "waybar"
    "kitty"
    "wofi"
    "gtk-3.0"
    "gtk-4.0"
    "fastfetch"
    "nwg-look"
    "qt5ct"
    "qt6ct"
    "dunst"
    "alacritty"
)

mkdir -p "$BACKUP_DIR"

for cfg in "${CONFIGS[@]}"; do
    if [ -e "$CONFIG_DIR/$cfg" ]; then
        echo "  -> $cfg"
        mkdir -p "$BACKUP_DIR/$(dirname "$cfg")"
        rm -rf "$BACKUP_DIR/$cfg"
        cp -r "$CONFIG_DIR/$cfg" "$BACKUP_DIR/$cfg"
    else
        echo "  -> $cfg (не найден, пропуск)"
    fi
done

# .bashrc отдельно
if [ -f "$HOME/.bashrc" ]; then
    echo "  -> .bashrc"
    cp "$HOME/.bashrc" "$DOTFILES_DIR/bashrc"
fi

# Список пакетов
echo "=== Сохраняю список пакетов ==="
pacman -Qqe > "$DOTFILES_DIR/packages.txt"
pacman -Qqm > "$DOTFILES_DIR/aur-packages.txt"

# Git
echo "=== Git ==="
cd "$DOTFILES_DIR"

git add .

if git diff --cached --quiet; then
    echo "Нет изменений для коммита."
    exit 0
fi

git commit -m "Update dotfiles: $(date '+%Y-%m-%d %H:%M:%S')"

if git remote -v | grep -q origin; then
    git push origin main
    echo "=== Запушено на GitHub ==="
else
    echo "=== Remote 'origin' не настроен. Коммит сделан локально. ==="
fi
