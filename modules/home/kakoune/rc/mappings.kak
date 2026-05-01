# rc/mappings.kak - Extended Keymaps for Kakoune
# Replicates Neovim keybindings and workflows

# ============================================================================
# General Navigation
# ============================================================================

# Jump to beginning of line (like Vim)
map global normal gh 'gh' -docstring 'Go to line start'
map global normal gl 'gl' -docstring 'Go to line end'

# Jump to start and end of file
map global normal gg 'gg' -docstring 'Go to start of file'
map global normal G 'G' -docstring 'Go to end of file'

# ============================================================================
# Selection and Deletion
# ============================================================================

# Select all (Ctrl+A)
define-command select-all %{
    execute-keys 'gg' '<a-;>' 'G'
}
map global normal <C-a> ':select-all<ret>' -docstring 'Select all'

# Delete line (alternative to dd)
map global normal <space>d '_<a-d>' -docstring 'Delete line'

# ============================================================================
# Clipboard Operations (Ctrl+C/V/X/Z/Y)
# ============================================================================

# Copy to system clipboard
define-command copy-selection %{
    execute-keys '|xclip -selection clipboard<ret>'
}
map global normal <C-c> ':copy-selection<ret>' -docstring 'Copy to clipboard'
map global visual <C-c> ':copy-selection<ret>' -docstring 'Copy to clipboard'

# Paste from system clipboard
map global normal <C-v> '!xclip -selection clipboard -o<ret>' -docstring 'Paste from clipboard'

# Undo/Redo with Ctrl+Z/Y
map global normal <C-z> 'u' -docstring 'Undo'
map global normal <C-y> '<a-u>' -docstring 'Redo'

# ============================================================================
# Insert Mode Clipboard
# ============================================================================

map global insert <C-v> '<esc>!xclip -selection clipboard -o<ret>i' -docstring 'Paste in insert mode'

# ============================================================================
# Buffer Management
# ============================================================================

# Previous/Next buffer
map global normal <space>bp ':buffer-previous<ret>' -docstring 'Previous buffer'
map global normal <space>bn ':buffer-next<ret>' -docstring 'Next buffer'

# ============================================================================
# Search and Replace (improved)
# ============================================================================

# Global find and replace
map global normal <space>s ':enter-user-mode search<ret>' -docstring 'Enter search mode'

define-command -hidden search-and-replace %{
    prompt 'Search:' %{ |grep }
}

# ============================================================================
# Window management (Kakoune uses splits)
# ============================================================================

# Split horizontal
map global normal <space>sh ':split<ret>' -docstring 'Split horizontal'

# Split vertical
map global normal <space>sv ':split -horizontal<ret>' -docstring 'Split vertical'

# Close current split
map global normal <space>sc ':delete-window<ret>' -docstring 'Close split'

# ============================================================================
# Command Mode Shortcuts
# ============================================================================

# Quick access commands
map global normal <space>w ':write<ret>' -docstring 'Save file'
map global normal <space>q ':quit<ret>' -docstring 'Quit'
map global normal <space>x ':delete-buffer<ret>' -docstring 'Close buffer'
map global normal <space>X ':delete-buffer!<ret>' -docstring 'Force close buffer'

# ============================================================================
# Line Operations
# ============================================================================

# Duplicate line
define-command duplicate-line %{
    execute-keys '<a-u><a-d>p'
}
map global normal <space>c ':duplicate-line<ret>' -docstring 'Duplicate line'

# Move line up/down (similar to Neovim)
define-command move-line-up %{
    execute-keys 'PP'
}
define-command move-line-down %{
    execute-keys 'pp'
}

# Visual mode line movements
map global normal <A-Up> ':move-line-up<ret>' -docstring 'Move line up'
map global normal <A-Down> ':move-line-down<ret>' -docstring 'Move line down'

# ============================================================================
# Text Objects and Operators
# ============================================================================

# Better word selection
map global normal <space>w 'b' -docstring 'Jump to start of word'
map global normal <space>e 'e' -docstring 'Jump to end of word'

# Inner word selection
map global normal <space>i '<a-i>' -docstring 'Expand selection inward'
map global normal <space>a '<a-a>' -docstring 'Expand selection outward'

# ============================================================================
# Commenting (requires treesitter or manual setup)
# ============================================================================

# Basic commenting - requires installation of commentary plugin or similar
# This is a placeholder that can be extended with actual comment functionality

# ============================================================================
# Indentation
# ============================================================================

# Auto indent
hook global InsertKey <ret> %{
    try %{ execute-keys -draft 'K<a-&>' }
}

# Manual indent increase/decrease
map global normal > '>|<ret>' -docstring 'Indent line'
map global normal < '<|<ret>' -docstring 'Dedent line'

# ============================================================================
# Insert Mode Enhancements
# ============================================================================

# Quick escape with Esc+Esc
map global insert <esc><esc> '<esc>' -docstring 'Exit insert mode'

# Auto pairs (basic implementation)
hook global InsertChar '[\[\(\{]' %{
    try %{
        execute-keys -draft 'hx'
        select %{
            if %val{selection} matches '[\[\(\{]'; then
                execute-keys 'a<close-bracket>'
            fi
        }
    }
}
