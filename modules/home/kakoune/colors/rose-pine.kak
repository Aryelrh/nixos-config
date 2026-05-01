# Rose Pine color scheme for Kakoune
# Inspired by the rose-pine theme for Neovim

# Rose Pine colors
set-option -add global ui_colors \
    "rgb:000000:rgb:191724:rgb:c4a7e7" \
    "rgb:000000:rgb:191724:rgb:f6c177" \
    "rgb:000000:rgb:191724:rgb:9ccfd8"

# Rose Pine palette
declare-option str rose_pine_base "rgb:191724"
declare-option str rose_pine_surface "rgb:1f1d2e"
declare-option str rose_pine_overlay "rgb:26233a"
declare-option str rose_pine_text "rgb:e0def4"
declare-option str rose_pine_love "rgb:eb6f92"
declare-option str rose_pine_gold "rgb:f6c177"
declare-option str rose_pine_iris "rgb:c4a7e7"
declare-option str rose_pine_pine "rgb:31748f"
declare-option str rose_pine_foam "rgb:9ccfd8"
declare-option str rose_pine_subtle "rgb:908caa"

# ============================================================================
# UI Elements
# ============================================================================

# Default colors
set-face global Default "rgb:e0def4,rgb:191724"
set-face global PrimarySelection "rgb:191724,rgb:c4a7e7"
set-face global SecondarySelection "rgb:191724,rgb:9ccfd8"
set-face global PrimaryCursor "rgb:191724,rgb:f6c177"
set-face global SecondaryCursor "rgb:191724,rgb:eb6f92"
set-face global LineNumberCursor "rgb:f6c177,rgb:26233a+b"
set-face global LineNumbers "rgb:6e6a86,rgb:191724"

# Whitespace
set-face global Whitespace "rgb:44415a+f"

# ============================================================================
# Errors & Warnings - No more yellow messages!
# ============================================================================

# Replace yellow message indicators
set-face global Error "rgb:eb6f92,rgb:191724+b"
set-face global Warning "rgb:f6c177,rgb:191724"
set-face global Information "rgb:9ccfd8,rgb:191724"
set-face global DiagnosticError "rgb:eb6f92"
set-face global DiagnosticWarning "rgb:f6c177"
set-face global DiagnosticHint "rgb:9ccfd8"

# Status bar
set-face global StatusLine "rgb:e0def4,rgb:26233a"
set-face global StatusLineMode "rgb:f6c177,rgb:26233a"
set-face global StatusLineInfo "rgb:9ccfd8,rgb:26233a"
set-face global StatusLinePrompt "rgb:eb6f92,rgb:26233a"

# ============================================================================
# Syntax Highlighting
# ============================================================================

# Keywords and operators
set-face global keyword "rgb:c4a7e7"
set-face global operator "rgb:f6c177"
set-face global type "rgb:9ccfd8"
set-face global string "rgb:f6c177"
set-face global value "rgb:eb6f92"
set-face global number "rgb:f6c177"
set-face global variable "rgb:e0def4"
set-face global function "rgb:9ccfd8"
set-face global comment "rgb:6e6a86+i"
set-face global module "rgb:31748f"

# ============================================================================
# Language Specific
# ============================================================================

# Markup
set-face global title "rgb:c4a7e7+b"
set-face global bullet "rgb:f6c177"
set-face global markup "rgb:f6c177"
set-face global link "rgb:9ccfd8+u"
set-face global list "rgb:f6c177"

# Diff
set-face global DiffAdded "rgb:31748f"
set-face global DiffRemoved "rgb:eb6f92"
set-face global Diffchanged "rgb:f6c177"

# ============================================================================
# Special highlighting (disables yellow notifications)
# ============================================================================

# Modify info box to not use yellow
set-face window information "rgb:9ccfd8,rgb:26233a"

# Attributes
set-face global Attribute "rgb:f6c177"
set-face global Reference "rgb:9ccfd8"
