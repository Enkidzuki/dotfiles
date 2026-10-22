#!/usr/bin/env bash

CURRENT=$(hyprshade current)
SHADER_DIR="$HOME/.config/hypr/shaders"

if [[ "$CURRENT" == *"greyscale"* ]]; then
    hyprshade on "$SHADER_DIR/crt.glsl"
elif [[ "$CURRENT" == *"crt"* ]]; then
    hyprshade on "$SHADER_DIR/vhs.glsl"
elif [[ "$CURRENT" == *"vhs"* ]]; then
    hyprshade on "$SHADER_DIR/glitch.glsl"
elif [[ "$CURRENT" == *"glitch"* ]]; then
    hyprshade on "$SHADER_DIR/pixelate.glsl"
elif [[ "$CURRENT" == *"pixelate"* ]]; then
    hyprshade on "$SHADER_DIR/hacker.glsl"
elif [[ "$CURRENT" == *"hacker"* ]]; then
    hyprshade on "$SHADER_DIR/cyberpunk.glsl"
elif [[ "$CURRENT" == *"cyberpunk"* ]]; then
    hyprshade on "$SHADER_DIR/vibrance.glsl"
elif [[ "$CURRENT" == *"vibrance"* ]]; then
    hyprshade on "$SHADER_DIR/matrix.glsl"
elif [[ "$CURRENT" == *"matrix"* ]]; then
    hyprshade off
else
    hyprshade on "$SHADER_DIR/greyscale.glsl"
fi
