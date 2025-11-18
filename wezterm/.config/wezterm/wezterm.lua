local wezterm = require 'wezterm'
local config = {}

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║  HINTERGRUND-ANIMATION - ZUFÄLLIGE AUSWAHL                                ║
-- ║  Bei jedem WezTerm-Start wird ein zufälliges Bild ausgewählt              ║
-- ║  Verfügbare Animationen in ~/.config/wezterm/animations/                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

-- Funktion zum Auswählen eines zufälligen Hintergrundbildes
local current_background = nil  -- Globale Variable für Status-Bar

local function get_random_background()
  local animations_dir = wezterm.home_dir .. '/.config/wezterm/animations'
  
  -- Liste aller verfügbaren Animationen
  local backgrounds = {
    'wavy-lines.gif',
    'wavy-cool-light-gradient.webp',
    'lightspeed-black-white.webp',
    'lightspeed-outlaws.webp',
    'lines.gif',
    'static.gif',
    'blob_blue.gif',
    'ai-speech.gif',
    'light-cool-gradients.webp',
    'light-rainbow-gradient.webp',
    'rainbow-down-light.webp',
  }
  
  -- Wähle ein zufälliges Bild aus
  math.randomseed(os.time())
  local random_index = math.random(1, #backgrounds)
  local selected_bg = backgrounds[random_index]
  
  -- Speichere für Status-Bar
  current_background = selected_bg
  
  wezterm.log_info('Selected random background: ' .. selected_bg)
  return animations_dir .. '/' .. selected_bg
end

-- [[ 1. FONT & LIGATUREN ]]
-- Verwenden Sie eine moderne Programmiererschrift (z.B. SFMono Nerd Font).
-- WezTerm verwendet den ersten verfügbaren Font aus der Liste.
config.font = wezterm.font_with_fallback {
  -- Primärer Font mit Ligaturen
  {
    family = 'SFMono Nerd Font',
    weight = 'Regular',
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  },
  -- Fallback-Fonts (in Reihenfolge der Priorität)
  'SF Mono',  -- Alternative Name für SFMono
  'Fira Code',
  'JetBrains Mono',
  'Noto Color Emoji',
  'monospace',
}

config.font_size = 14.0

-- [[ 2. VISUELLE ÄSTHETIK & OPACITÄT ]]

-- Opazität (0.95 ist leicht transparent; 1.0 ist opak)
config.window_background_opacity = 0.95

-- Hintergrund-Bild/Animation
-- OPTION 1: Zufälliges Bild bei jedem Start (AKTIV)
local bg_image = get_random_background()

-- OPTION 2: Festes Bild (zum Aktivieren: obige Zeile auskommentieren und eine der folgenden aktivieren)
-- local bg_image = wezterm.home_dir .. '/.config/wezterm/animations/wavy-lines.gif'
-- local bg_image = wezterm.home_dir .. '/.config/wezterm/animations/lightspeed-black-white.webp'
-- local bg_image = wezterm.home_dir .. '/.config/wezterm/animations/lines.gif'
-- local bg_image = wezterm.home_dir .. '/.config/wezterm/animations/wavy-cool-light-gradient.webp'

config.background = {
  {
    source = { File = bg_image },
    -- Wie das Bild angezeigt wird
    width = '100%',
    height = '100%',
    -- Opacity des Hintergrundbildes (0.0 = unsichtbar, 1.0 = vollständig sichtbar)
    opacity = 0.45,  -- Erhöht für bessere Sichtbarkeit
    -- Horizontale Ausrichtung: 'Left', 'Center', 'Right'
    horizontal_align = 'Center',
    -- Vertikale Ausrichtung: 'Top', 'Middle', 'Bottom'
    vertical_align = 'Middle',
    -- Wie das Bild wiederholt wird: 'NoRepeat', 'Repeat', 'Mirror'
    repeat_x = 'NoRepeat',
    repeat_y = 'NoRepeat',
    -- Wie das Bild skaliert wird
    -- 'Fit' = passt ins Fenster, 'Cover' = füllt das Fenster
    hsb = {
      brightness = 0.4,   -- Erhöht für bessere Sichtbarkeit (0.0 - 1.0)
      hue = 1.0,          -- Farbton beibehalten
      saturation = 1.0,   -- Sättigung beibehalten
    },
  },
  -- Halbtransparenter Overlay für bessere Lesbarkeit
  {
    source = { Color = '#282a36' },
    width = '100%',
    height = '100%',
    opacity = 0.55,  -- Reduziert für mehr Hintergrund-Sichtbarkeit
  },
}

-- Fügt Ränder um den Terminalinhalt hinzu (verbessert die Lesbarkeit)
config.window_padding = {
  left = 12,
  right = 12,
  top = 8,
  bottom = 8,
}

-- DEFINIERTE STARTGRÖSSE
config.initial_cols = 120
config.initial_rows = 28

-- Maximiert WezTerm zu Fullscreen beim Start (Linux)
-- Hinweis: Die automatische Maximierung über WezTerm API kann auf Linux problematisch sein.
-- Alternative Lösungen:
-- 1. Verwende deinen Window Manager (z.B. i3, KDE, GNOME) um WezTerm beim Start zu maximieren
-- 2. Verwende Ctrl+a + f nach dem Start, um manuell zu maximieren
-- 3. Erstelle ein Startup-Script, das WezTerm startet und dann maximiert

-- Deaktiviert: Automatische Maximierung (verursacht Fehler auf Linux)
-- wezterm.on('gui-startup', function(cmd)
--   -- Code entfernt, da gui_window() auf Linux nicht zuverlässig funktioniert
-- end)

-- Farbschema (Dracula) - mit Hintergrundbild kombiniert
config.colors = {
    -- Hintergrund wird durch config.background gesteuert
    -- background = '#282a36',  -- Auskommentiert, da wir Hintergrundbilder verwenden
    foreground = '#f8f8f2',
    cursor_bg = '#f8f8f2',
    cursor_fg = '#282a36',
    
    -- Normale Farben
    ansi = {
        '#21222c', -- Black
        '#ff5555', -- Red
        '#50fa7b', -- Green
        '#f1fa8c', -- Yellow
        '#bd93f9', -- Blue
        '#ff79c6', -- Magenta
        '#8be9fd', -- Cyan
        '#f8f8f2', -- White
    },
    -- Helle Farben (Bright)
    brights = {
        '#6272a4', -- Bright Black
        '#ff6e6e', -- Bright Red
        '#69ff94', -- Bright Green
        '#ffffa5', -- Bright Yellow
        '#d6acff', -- Bright Blue
        '#ff92df', -- Bright Magenta
        '#a4ffff', -- Bright Cyan
        '#ffffff', -- Bright White
    },
    
    -- Tab-Leiste Farben
    tab_bar = {
        -- Aktiver Tab
        active_tab = {
            bg_color = '#282a36',
            fg_color = '#f8f8f2',
            intensity = 'Bold',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },
        -- Inaktiver Tab
        inactive_tab = {
            bg_color = '#21222c',
            fg_color = '#6272a4',
        },
        -- Inaktiver Tab beim Hover
        inactive_tab_hover = {
            bg_color = '#44475a',
            fg_color = '#f8f8f2',
            italic = false,
        },
        -- Neuer Tab Button
        new_tab = {
            bg_color = '#21222c',
            fg_color = '#6272a4',
        },
        -- Neuer Tab Button beim Hover
        new_tab_hover = {
            bg_color = '#44475a',
            fg_color = '#f8f8f2',
            italic = false,
        },
    },
}

-- [[ 3. TAB- & FENSTER-STEUERUNG ]]

-- Zeigt die Titelleiste mit transparentem Hintergrund
config.window_decorations = "TITLE | RESIZE"

-- Transparenter Fensterrahmen (inkl. Titelleiste)
-- Verwende Terminal-Hintergrundfarbe für nahtlose Integration
config.window_frame = {
  -- Fensterrahmen-Farben (passend zum Terminal-Hintergrund)
  active_titlebar_bg = '#282a36',  -- Gleiche Farbe wie Terminal-Hintergrund
  inactive_titlebar_bg = '#21222c',  -- Etwas dunkler für inaktive Fenster
  
  -- Button-Farben (sichtbar aber dezent)
  button_fg = '#f8f8f2',
  button_bg = '#282a36',  -- Gleiche Farbe wie Hintergrund
  button_hover_fg = '#ffffff',
  button_hover_bg = '#44475a',  -- Sichtbar beim Hover
  
  -- Text-Farben
  active_titlebar_fg = '#f8f8f2',
  inactive_titlebar_fg = '#6272a4',
  
  -- Border entfernt für sauberen Look
  border_left_width = '0px',
  border_right_width = '0px',
  border_bottom_height = '0px',
  border_top_height = '0px',
}

-- Zeigt die Tabs am unteren Rand (modernere Platzierung)
config.tab_bar_at_bottom = true

-- Tab-Leiste Konfiguration
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 16
config.use_fancy_tab_bar = true

-- Status Bar mit Fullscreen-Button und Hintergrund-Info
wezterm.on('update-right-status', function(window, pane)
  local is_fullscreen = window:gui_window():is_fullscreen()
  local fullscreen_text = is_fullscreen and '⛶ Exit Fullscreen' or '⛶ Fullscreen'
  
  -- Zeige aktuelles Hintergrundbild
  local bg_text = current_background or 'No background'
  -- Kürze den Namen für bessere Lesbarkeit
  bg_text = bg_text:gsub('%.gif', ''):gsub('%.webp', ''):gsub('%-', ' ')
  
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#bd93f9' } },
    { Text = '🎨 ' .. bg_text },
    { Foreground = { Color = '#6272a4' } },
    { Text = ' | ' },
    { Foreground = { Color = '#f8f8f2' } },
    { Text = fullscreen_text },
    { Foreground = { Color = '#6272a4' } },
    { Text = ' | ' },
    { Foreground = { Color = '#f8f8f2' } },
    { Text = 'Right-click for menu' },
  }))
end)

-- Right-Click Context Menu mit Fullscreen-Option
wezterm.on('show-right-click-menu', function(window, pane, items)
  -- Füge Fullscreen-Option zum Menü hinzu
  local is_fullscreen = window:gui_window():is_fullscreen()
  table.insert(items, {
    label = is_fullscreen and 'Exit Fullscreen' or 'Enter Fullscreen',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(wezterm.action.ToggleFullScreen, pane)
    end),
  })
  return items
end)


-- [[ 4. KEY BINDINGS (Tmux-Stil) ]]
-- Diese Bindings ermöglichen Splits und Panes, ohne Tmux selbst starten zu müssen
-- WICHTIG: Leader Key auf Ctrl+Space geändert, damit Ctrl+a an tmux durchgereicht wird
config.leader = { key = 'Space', mods = 'CTRL' }

config.keys = {
  -- Split horizontal (Ctrl+Space + %)
  { key = '%', mods = 'LEADER', action = wezterm.action{ SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
  -- Split vertical (Ctrl+Space + ")
  { key = '"', mods = 'LEADER', action = wezterm.action{ SplitVertical = { domain = 'CurrentPaneDomain' } } },
  
  -- Navigiere zwischen Panes (Ctrl+Space + Pfeiltasten)
  { key = 'LeftArrow', mods = 'LEADER', action = wezterm.action{ ActivatePaneDirection = 'Left' } },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action{ ActivatePaneDirection = 'Right' } },
  { key = 'UpArrow', mods = 'LEADER', action = wezterm.action{ ActivatePaneDirection = 'Up' } },
  { key = 'DownArrow', mods = 'LEADER', action = wezterm.action{ ActivatePaneDirection = 'Down' } },

  -- Schließe Pane (Ctrl+Space + x)
  { key = 'x', mods = 'LEADER', action = wezterm.action{ CloseCurrentPane = { confirm = true } } },

  -- Erstelle einen neuen Tab (Ctrl+Space + c)
  { key = 'c', mods = 'LEADER', action = wezterm.action{ SpawnTab = 'CurrentPaneDomain' } },

  -- Wechsle zum nächsten Tab (Ctrl+Space + n)
  { key = 'n', mods = 'LEADER', action = wezterm.action{ ActivateTabRelative = 1 } },
  
  -- Toggle Fullscreen (Ctrl+Space + f)
  { key = 'f', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
  
  -- Toggle Fullscreen (F11 - Standard)
  { key = 'F11', mods = 'NONE', action = wezterm.action.ToggleFullScreen },
}

-- Right-Click Context Menu mit Fullscreen-Button
wezterm.on('show-right-click-menu', function(window, pane, items)
  -- Füge Fullscreen-Option zum Menü hinzu
  table.insert(items, {
    label = 'Toggle Fullscreen',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(wezterm.action.ToggleFullScreen, pane)
    end),
  })
  return items
end)

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║  TAB TITLE - SHOW TMUX SESSION NAME                                       ║
-- ║  WezTerm tabs will display the current tmux session name                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_index + 1  -- Default to tab number
  local pane = tab.active_pane
  
  -- Check if we're inside a tmux session
  if pane and pane.user_vars and pane.user_vars.TMUX then
    -- Get tmux session name from the pane title or foreground process
    local tmux_session = pane.title:match('^%[(.-)%]') or pane.user_vars.TMUX_SESSION
    if tmux_session then
      title = '󱂬 ' .. tmux_session  -- Nerd font tmux icon + session name
    end
  end
  
  -- Fallback: use pane title if available
  if not pane.user_vars or not pane.user_vars.TMUX then
    if pane.title and #pane.title > 0 then
      title = pane.title
    end
  end
  
  -- Styling for active vs inactive tabs
  local background = '#282a36'
  local foreground = '#f8f8f2'
  
  if tab.is_active then
    background = '#bd93f9'  -- Dracula purple for active tab
    foreground = '#282a36'
  elseif hover then
    background = '#44475a'  -- Dracula selection for hover
    foreground = '#f8f8f2'
  end
  
  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = ' ' .. title .. ' ' },
  }
end)

return config
