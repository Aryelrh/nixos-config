# rc/ui.kak - UI Configuration for Kakoune
# Configures UI elements to remove default yellow messages and match Neovim aesthetic

# ============================================================================
# Status Bar Configuration
# ============================================================================

# Disable default mode line info (removes yellow notifications)
set-option global modelinefmt '%{{context_info}%{mode_info}%%{--}%{client}%%{--}%{bufname}%%{--}%{cursor_line}:%{cursor_column}}'

# ============================================================================
# Information Box (removes yellow colored info)
# ============================================================================

# Set info box position
set-option global infobox bottom

# ============================================================================
# Completion Menu
# ============================================================================

# Disable automatic completion to avoid clutter
set-option global autocomplete off

# Completion prefix minimum
set-option global completer explicit

# ============================================================================
# Menu Configuration
# ============================================================================

# Menu colors and style
set-face window menu "rgb:e0def4,rgb:26233a"
set-face window MenuBackground "rgb:6e6a86,rgb:26233a"
set-face window MenuForeground "rgb:f6c177,rgb:26233a"

# ============================================================================
# Search Highlighting
# ============================================================================

# Remove default search highlighting color (often yellow)
set-face window Search "rgb:e0def4,rgb:26233a+u"
set-face window SearchCurrent "rgb:191724,rgb:f6c177"

# ============================================================================
# Line Numbering
# ============================================================================

# Enable relative line numbers with custom colors
add-highlighter global/ number-lines -hlcursor -relative

# Custom line number colors  
set-face window LineNumbers "rgb:6e6a86,rgb:191724"
set-face window LineNumberCursor "rgb:f6c177,rgb:26233a+b"

# ============================================================================
# Cursor and Selection
# ============================================================================

# Primary cursor (main editing position)
set-face window PrimaryCursor "rgb:191724,rgb:f6c177"

# Secondary selections
set-face window SecondarySelection "rgb:191724,rgb:9ccfd8"
set-face window SecondaryCursor "rgb:191724,rgb:9ccfd8"

# ============================================================================
# Indentation Guides
# ============================================================================

# Enable indentation guides (replaces visual feedback)
add-highlighter global/ indent guides

# Custom indent color (subtle)
set-face window indent "rgb:44415a+f"

# ============================================================================
# Whitespace Visibility
# ============================================================================

# Show trailing spaces and tabs (without yellow highlighting)
add-highlighter global/ show-whitespace

set-face window Whitespace "rgb:44415a"

# ============================================================================
# Diff and Git
# ============================================================================

# Diff coloring
set-face window DiffAdded "rgb:31748f"
set-face window DiffRemoved "rgb:eb6f92"
set-face window DiffChanged "rgb:f6c177"

# ============================================================================
# Highlight current line
# ============================================================================

# Subtle background for current line
add-highlighter global/ line %val{cursor_line} "%{LineNumberCursor}"

# ============================================================================
# Scrollbar (if terminal supports)
# ============================================================================

# Keep terminal UI consistent
set-option global ui_options ncurses_assistant=clippy ncurses_enable_mouse=true

# ============================================================================
# Command Box
# ============================================================================

# Prompt coloring (remove yellow)
set-face window Prompt "rgb:c4a7e7,rgb:26233a+b"

# ============================================================================
# Error and Warning Messages (Priority fix - no more yellow!)
# ============================================================================

# Override default message colors to remove yellow
set-face global Error "rgb:eb6f92,rgb:191724+b"
set-face global Warning "rgb:f6c177,rgb:26233a"
set-face global Information "rgb:9ccfd8,rgb:26233a"

# Status line (where messages appear)
set-face global StatusLine "rgb:e0def4,rgb:26233a"

# Make info messages not yellow but instead use iris (purple)
set-face window information "rgb:c4a7e7,rgb:26233a"
