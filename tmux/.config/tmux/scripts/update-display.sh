#!/bin/bash
# Update DISPLAY environment variable in tmux from the current environment

# Versuche DISPLAY aus verschiedenen Quellen zu bekommen
if [ -z "$DISPLAY" ]; then
    # Versuche DISPLAY aus systemctl zu holen
    DISPLAY=$(systemctl --user show-environment 2>/dev/null | grep "^DISPLAY=" | cut -d= -f2)
fi

if [ -z "$DISPLAY" ]; then
    # Versuche DISPLAY aus einem laufenden X-Prozess zu ermitteln
    DISPLAY=$(ps -u $(id -u) -o pid= -o args= | grep -m1 "Xorg\|X\s" | sed -n 's/.*\s:\([0-9]\+\).*/:\1/p')
fi

if [ -z "$DISPLAY" ]; then
    # Standard-Fallback
    DISPLAY=":0"
fi

# Setze DISPLAY in der tmux Umgebung
tmux set-environment -g DISPLAY "$DISPLAY"

# Setze DISPLAY auch in der aktuellen Shell
export DISPLAY="$DISPLAY"

echo "DISPLAY updated to: $DISPLAY"

