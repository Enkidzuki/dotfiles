#!/bin/bash
sleep 3
if ! pgrep -x "awww-daemon" >/dev/null; then
  awww-daemon &
  disown
  sleep 1
  awww img /path/to/your/wallpaper.png
fi
