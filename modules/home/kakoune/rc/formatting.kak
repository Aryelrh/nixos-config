# rc/formatting.kak - Auto-formatting and Language-specific Settings
# Equivalent to Neovim conform.nvim configuration

# ============================================================================
# General Formatting
# ============================================================================

# Auto format on save
hook global BufWritePre .* %{
    try %{
        evaluate-commands %sh{
            case "$kak_buffile" in
                *.lua)  echo "execute-keys ':format-lua'" ;;
                *.py)   echo "execute-keys ':format-python'" ;;
                *.js|*.jsx)  echo "execute-keys ':format-javascript'" ;;
                *.ts|*.tsx)  echo "execute-keys ':format-typescript'" ;;
                *.rs)   echo "execute-keys ':format-rust'" ;;
                *.java) echo "execute-keys ':format-java'" ;;
                *.css|*.scss) echo "execute-keys ':format-css'" ;;
                *.html|*.htm) echo "execute-keys ':format-html'" ;;
            esac
        }
    }
}

# ============================================================================
# Lua Formatting (stylua)
# ============================================================================

define-command format-lua %{
    set-option buffer formatcmd 'stylua -'
    try %{
        execute-keys '%|<space><ret>'
    } catch %{
        echo "stylua not found or format failed"
    }
}

hook global WinSetOption filetype=lua %{
    set-option buffer formatcmd 'stylua -'
}

# ============================================================================
# Python Formatting (black + isort)
# ============================================================================

define-command format-python %{
    try %{
        execute-keys '%|isort -<ret>'
        execute-keys '%|black -<ret>'
    } catch %{
        echo "isort or black not found"
    }
}

hook global WinSetOption filetype=python %{
    set-option buffer formatcmd 'black -'
    set-option buffer linter_cmd 'pylint'
}

# ============================================================================
# JavaScript/TypeScript Formatting (prettier)
# ============================================================================

define-command format-javascript %{
    try %{
        execute-keys '%|prettier --parser babel<ret>'
    } catch %{
        echo "prettier not found"
    }
}

define-command format-typescript %{
    try %{
        execute-keys '%|prettier --parser typescript<ret>'
    } catch %{
        echo "prettier not found"
    }
}

hook global WinSetOption filetype=javascript %{
    set-option buffer formatcmd 'prettier --parser babel'
}

hook global WinSetOption filetype=typescript %{
    set-option buffer formatcmd 'prettier --parser typescript'
}

hook global WinSetOption filetype=typescriptreact %{
    set-option buffer formatcmd 'prettier --parser typescript'
}

hook global WinSetOption filetype=javascriptreact %{
    set-option buffer formatcmd 'prettier --parser babel'
}

# ============================================================================
# Rust Formatting (rustfmt)
# ============================================================================

define-command format-rust %{
    try %{
        execute-keys '%|rustfmt<ret>'
    } catch %{
        echo "rustfmt not found"
    }
}

hook global WinSetOption filetype=rust %{
    set-option buffer formatcmd 'rustfmt'
}

# ============================================================================
# Java Formatting (google-java-format)
# ============================================================================

define-command format-java %{
    try %{
        execute-keys '%|google-java-format -<ret>'
    } catch %{
        echo "google-java-format not found"
    }
}

hook global WinSetOption filetype=java %{
    set-option buffer formatcmd 'google-java-format -'
}

# ============================================================================
# CSS Formatting (prettier)
# ============================================================================

define-command format-css %{
    try %{
        execute-keys '%|prettier --parser css<ret>'
    } catch %{
        echo "prettier not found"
    }
}

hook global WinSetOption filetype=css %{
    set-option buffer formatcmd 'prettier --parser css'
}

hook global WinSetOption filetype=scss %{
    set-option buffer formatcmd 'prettier --parser scss'
}

# ============================================================================
# HTML Formatting (prettier)
# ============================================================================

define-command format-html %{
    try %{
        execute-keys '%|prettier --parser html<ret>'
    } catch %{
        echo "prettier not found"
    }
}

hook global WinSetOption filetype=html %{
    set-option buffer formatcmd 'prettier --parser html'
}

# ============================================================================
# JSON Formatting (prettier)
# ============================================================================

hook global WinSetOption filetype=json %{
    set-option buffer formatcmd 'prettier --parser json'
}

# ============================================================================
# SQL Formatting
# ============================================================================

hook global WinSetOption filetype=sql %{
    set-option buffer lster_cmd 'sqlint'
}

# ============================================================================
# Language-specific Indentation
# ============================================================================

# Python: 4 spaces
hook global WinSetOption filetype=python %{
    set-option buffer tabstop 4
    set-option buffer indentwidth 4
}

# Default: 2 spaces (for most languages)
hook global WinSetOption filetype=lua %{
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
}

hook global WinSetOption filetype=javascript %{
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
}

hook global WinSetOption filetype=typescript %{
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
}

hook global WinSetOption filetype=rust %{
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
}

hook global WinSetOption filetype=java %{
    set-option buffer tabstop 4
    set-option buffer indentwidth 4
}
