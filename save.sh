#!/bin/bash
set -e

DOTFILES_DIR="$HOME/repos/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$DOTFILES_DIR/configs"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Сохранение конфигов в dotfiles ===${NC}"

# Список конфигов, которые нужно сохранять
CONFIGS=(
    "hypr"
    "waybar"
    "kitty"
    "wofi"
    "gtk-3.0"
    "gtk-4.0"
    "fastfetch"
    "starship.toml"
    "nwg-look"
    "qt5ct"
    "qt6ct"
    "sddm"
    "dunst"
    "alacritty"
)

# Копируем каждый конфиг
for cfg in "${CONFIGS[@]}"; do
    if [ -e "$CONFIG_DIR/$cfg" ]; then
        echo -e "  ${GREEN}->${NC} $cfg"
        mkdir -p "$BACKUP_DIR/$(dirname "$cfg")"
        rm -rf "$BACKUP_DIR/$cfg"
        cp -r "$CONFIG_DIR/$cfg" "$BACKUP_DIR/$cfg"
    else
        echo -e "  ${RED}->${NC} $cfg ${YELLOW}(не найден, пропуск)${NC}"
    fi
done

# Сохраняем .bashrc
if [ -f "$HOME/.bashrc" ]; then
    echo -e "  ${GREEN}->${NC} .bashrc"
    cp "$HOME/.bashrc" "$DOTFILES_DIR/bashrc"
fi

# Сохраняем список пакетов
echo -e "${YELLOW}=== Сохранение списка пакетов ===${NC}"
pacman -Qqe > "$DOTFILES_DIR/packages.txt"
pacman -Qqm > "$DOTFILES_DIR/aur-packages.txt"
echo -e "  ${GREEN}->${NC} packages.txt ($(wc -l < "$DOTFILES_DIR/packages.txt") пакетов)"
echo -e "  ${GREEN}->${NC} aur-packages.txt ($(wc -l < "$DOTFILES_DIR/aur-packages.txt") пакетов)"

echo -e "${GREEN}=== Готово! ===${NC}"
