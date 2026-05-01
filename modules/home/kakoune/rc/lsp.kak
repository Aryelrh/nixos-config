# rc/lsp.kak - LSP Configuration for Kakoune
# Provides Language Server Protocol support with equivalent functionality to Neovim LSP

# ============================================================================
# LSP Server Setup
# ============================================================================

# Initialize kak-lsp if available
eval %sh{
    if command -v kak-lsp >/dev/null 2>&1; then
        echo "
# Enable LSP diagnostics
set-option global lsp_diagnostic_line_error_sign '●'
set-option global lsp_diagnostic_line_warning_sign '●'
set-option global lsp_auto_hover_insert_mode false
set-option global lsp_hover_anchor true

# LSP Language configurations
set-option global lsp_server_configuration lua-language-server=%{
    {settings: {Lua: {runtime: {version: \"LuaJIT\"}, diagnostics: {globals: [\"vim\"]}}}}
}

# Hook to start LSP on supported file types
hook global WinCreate .* %{
    lsp-enable
}

# Diagnostics highlighting
add-highlighter global/ lsp-diagnostic-line-error
add-highlighter global/ lsp-diagnostic-line-warning
        "
    fi
}

# ============================================================================
# LSP Hover
# ============================================================================

# Hover definition
map global normal K ':lsp-hover<ret>' -docstring 'Hover'

# ============================================================================
# LSP References and Navigation
# ============================================================================

# Go to definition
map global normal gd ':lsp-definition<ret>' -docstring 'Go to definition'

# Go to declaration
map global normal gD ':lsp-declaration<ret>' -docstring 'Go to declaration'

# Go to implementation
map global normal gi ':lsp-implementation<ret>' -docstring 'Go to implementation'

# Show all references
map global normal gr ':lsp-references --no-filter<ret>' -docstring 'Show references'

# ============================================================================
# LSP Code Actions and Refactoring
# ============================================================================

# Rename symbol
map global normal <space>rn ':lsp-rename-prompt<ret>' -docstring 'Rename symbol'

# Code actions
map global normal <space>ca ':lsp-code-action<ret>' -docstring 'Code actions'

# Format buffer
map global normal <space>f ':lsp-format<ret>' -docstring 'Format buffer'

# ============================================================================
# LSP Diagnostics
# ============================================================================

# Show diagnostic for current line
map global normal <space>e ':lsp-diagnostic-lines-info<ret>' -docstring 'Show diagnostics'

# Go to previous diagnostic
map global normal '[d' ':lsp-prev-diagnostic<ret>' -docstring 'Previous diagnostic'

# Go to next diagnostic
map global normal ']d' ':lsp-next-diagnostic<ret>' -docstring 'Next diagnostic'

# ============================================================================
# Completion
# ============================================================================

# LSP completion integration
hook global InsertIdle .* %{
    try %{ execute-keys -draft 'h<a-k>\S.<ret>m' }
}

# Trigger completion manually
map global insert <c-space> '<esc>:try %{ execute-keys :lsp-completion }<ret>'
