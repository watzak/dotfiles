# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm tmux)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="$PATH:$HOME/Downloads/Software/flutter/bin"

# Flatpak exports (for WezTerm and other flatpak apps)
if [ -d "$HOME/.local/share/flatpak/exports/bin" ]; then
    export PATH="$PATH:$HOME/.local/share/flatpak/exports/bin"
fi
if [ -d "/var/lib/flatpak/exports/bin" ]; then
    export PATH="$PATH:/var/lib/flatpak/exports/bin"
fi

# WezTerm function (if not in PATH, use flatpak)
if ! command -v wezterm &> /dev/null; then
    wezterm() {
        flatpak run org.wezfurlong.wezterm "$@"
    }
fi


# brew
# eval "$(starship init zsh)" 
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

# shellcheck shell=bash

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
\builtin typeset -ga precmd_functions
\builtin typeset -ga chpwd_functions
# shellcheck disable=SC2034,SC2296
precmd_functions=("${(@)precmd_functions:#__zoxide_hook}")
# shellcheck disable=SC2034,SC2296
chpwd_functions=("${(@)chpwd_functions:#__zoxide_hook}")
chpwd_functions+=(__zoxide_hook)

# Report common issues.
function __zoxide_doctor() {
    [[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
    [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0

    _ZO_DOCTOR=0
    \builtin printf '%s\n' \
        'zoxide: detected a possible configuration issue.' \
        'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' \
        '' \
        'If the issue persists, consider filing an issue at:' \
        'https://github.com/ajeetdsouza/zoxide/issues' \
        '' \
        'Disable this message by setting _ZO_DOCTOR=0.' \
        '' >&2
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    __zoxide_doctor
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
        __zoxide_cd "$2"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _cd -/

        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Set a result to ensure completion doesn't re-run
            compadd -Q ""

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Sends query device status code, which results in a '\e[0n' being sent to console input.
            \builtin printf '\e[5n'

            # Report that the completion was successful, so that we don't fall back
            # to another completion function.
            return 0
        fi
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            __zoxide_result=''
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================
#
# To initialize zoxide, add this to your shell configuration file (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"

# --- ZOXIDE HISTORY IMPORT (Einmalige Initialisierung) ---

function zoxide_import_history() {
    # Prüft, ob Zoxide installiert ist und die History-Datei existiert
    if ! command -v zoxide &> /dev/null || [ ! -f "$HOME/.zsh_history" ]; then
        return 1
    fi

    echo "--- Zoxide: Importiere History-Pfade aus .zsh_history ---"
    
    # Der Kern-Befehl:
    grep -h "^cd " "$HOME/.zsh_history" \
    | sed 's|^cd ||' \
    | sed "s|^~|$HOME|" \
    | sort -u \
    | while read dir; do
        # Fügt das Verzeichnis nur hinzu, wenn es tatsächlich existiert (-d)
        [ -d "$dir" ] && zoxide add "$dir"
    done

    echo "Zoxide Import abgeschlossen."
}

# Führen Sie die Funktion einmal aus, bevor Sie die Zoxide-Initialisierung starten.
# Danach können Sie sie auskommentieren oder entfernen.
zoxide_import_history


fastfetch

# --- FIX DISPLAY IN TMUX ---
# Stelle sicher, dass DISPLAY in tmux Sessions gesetzt ist (für GUI-Anwendungen)
if [ -n "$TMUX" ] && [ -z "$DISPLAY" ]; then
    # Hole DISPLAY aus der tmux Umgebung
    export DISPLAY=$(tmux show-environment DISPLAY 2>/dev/null | cut -d= -f2)
    
    # Fallback: Versuche DISPLAY aus systemd zu holen
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=$(systemctl --user show-environment 2>/dev/null | grep "^DISPLAY=" | cut -d= -f2)
    fi
    
    # Fallback: Standard DISPLAY
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=":0"
    fi
fi

# --- TMUX INTERACTIVE START SKRIPT (Für .zshrc) ---
# Startet Tmux oder stellt die Verbindung wieder her, mit interaktiver Auswahl
# für bestehende Sitzungen oder der Eingabe eines Namens für eine neue Sitzung.
# Unterstützt tmux-continuum für automatische Wiederherstellung nach Reboot.

function tmux_interactive_start() {
    # 1. Prüfen, ob wir uns bereits in einer Tmux-Sitzung befinden ($TMUX muss leer sein).
    # Wenn TMUX gesetzt ist, wird die Funktion sofort beendet (return).
    [ -z "$TMUX" ] || return

    # 2. Überprüfen, ob eine gespeicherte Session existiert (tmux-resurrect)
    # Wenn ja, tmux starten und continuum die Session automatisch wiederherstellen lassen
    if [ -f "$HOME/.local/share/tmux/resurrect/last" ]; then
        # Prüfen, ob es aktuell laufende Sessions gibt
        local running_sessions
        running_sessions=($(tmux list-sessions -F "#S" 2>/dev/null))
        
        # Wenn keine Sessions laufen, starte tmux und lasse continuum die letzte Session wiederherstellen
        if [ ${#running_sessions[@]} -eq 0 ]; then
            echo "🔄 Wiederherstellung der letzten tmux Session..."
            tmux new-session -d -s resurrect_temp
            sleep 0.5  # Kurze Pause, damit continuum die Session wiederherstellen kann
            tmux kill-session -t resurrect_temp 2>/dev/null
            sleep 0.5
            
            # Jetzt sollten die wiederhergestellten Sessions verfügbar sein
            running_sessions=($(tmux list-sessions -F "#S" 2>/dev/null))
        fi
    fi

    # 3. Alle laufenden Sitzungsnamen abrufen
    local sessions
    sessions=($(tmux list-sessions -F "#S" 2>/dev/null))
    local session

    # 4. Wenn Sitzungen gefunden wurden, interaktive Auswahl anzeigen
    if [ ${#sessions[@]} -gt 0 ]; then
        PS3="Bitte wählen Sie eine Tmux-Session: "
        echo "-----------------------------------"
        echo "Verfügbare Tmux Sessions:"
        echo "-----------------------------------"

        # 'select' erstellt ein interaktives Menü
        select session in "${sessions[@]}"
        do
            # Überprüfen, ob eine gültige Auswahl getroffen wurde
            if [ -n "$session" ]; then
                tmux attach-session -t "$session"
                return
            else
                echo "Ungültige Auswahl. Bitte erneut versuchen."
            fi
        done
    fi

    # 5. Wenn keine Sitzungen oder Auswahl abgebrochen: Neue Sitzung erstellen
    read -rp "Neue Tmux Session benennen (Enter für Standard-Session): " SESSION_NAME

    if [ -z "$SESSION_NAME" ]; then
        # Startet eine unbenannte Standard-Session (tmux new)
        tmux
    else
        # Startet eine neue benannte Session
        tmux new -s "$SESSION_NAME"
    fi
}

# Tmux-Startskript ausführen, nur wenn die Shell interaktiv ist
[[ $- == *i* ]] && tmux_interactive_start
