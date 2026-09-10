#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "=== Установка dotfiles ==="

# 1. Установка yay (если нет)
if ! command -v yay &> /dev/null; then
    echo ">>> Устанавливаю yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~
fi

# 2. Установка пакетов из официальных репозиториев
if [ -f "$DOTFILES_DIR/packages.txt" ]; then
    echo ">>> Устанавливаю пакеты из packages.txt..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages.txt"
fi

# 3. Установка AUR-пакетов
if [ -f "$DOTFILES_DIR/aur-packages.txt" ]; then
    echo ">>> Устанавливаю AUR-пакеты..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/aur-packages.txt"
fi

# 4. Копирование конфигов
echo ">>> Копирую конфиги..."
mkdir -p "$CONFIG_DIR"
for dir in "$DOTFILES_DIR/configs"/*; do
    name=$(basename "$dir")
    echo "  -> $name"
    rm -rf "$CONFIG_DIR/$name"
    cp -r "$dir" "$CONFIG_DIR/$name"
done

# 5. Включение сервисов
echo ">>> Включаю сервисы..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now sddm

# 6. Готово
echo "=== Установка завершена! Перезагрузись. ==="
