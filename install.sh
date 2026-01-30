#!/usr/bin/env bash
#
# ap-hop installer
# Downloads and installs ap-hop to ~/.local/bin and ensures it's in PATH
#

set -euo pipefail

readonly INSTALL_DIR="$HOME/.local/bin"
readonly SCRIPT_NAME="ap-hop"
readonly SCRIPT_URL="https://raw.githubusercontent.com/joshschmelzle/ap-hop/main/ap-hop"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' 

info() {
    echo -e "${BLUE}➜${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

error() {
    echo -e "${RED}✗${NC} $*" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

get_install_cmd() {
    local pkg="$1"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ "$pkg" == "sshpass" ]]; then
            echo "brew install hudochenkov/sshpass/sshpass"
        else
            echo "brew install $pkg"
        fi
    elif command_exists apt-get; then
        echo "sudo apt-get install $pkg"
    elif command_exists yum; then
        echo "sudo yum install $pkg"
    elif command_exists dnf; then
        echo "sudo dnf install $pkg"
    elif command_exists pacman; then
        echo "sudo pacman -S $pkg"
    else
        echo "Install $pkg using your package manager"
    fi
}

check_dependencies() {
    local missing=0

    info "Checking dependencies..."

    if ! command_exists curl; then
        error "curl not found - required for installation"
        echo "  Install with: $(get_install_cmd curl)"
        exit 1
    fi
    success "curl found"

    if ! command_exists jq; then
        warn "jq not found - required to run ap-hop"
        echo "  Install with: $(get_install_cmd jq)"
        missing=1
    else
        success "jq found"
    fi

    if ! command_exists sshpass; then
        warn "sshpass not found - required to run ap-hop"
        echo "  Install with: $(get_install_cmd sshpass)"
        missing=1
    else
        success "sshpass found"
    fi

    if [[ $missing -eq 1 ]]; then
        echo ""
        warn "Missing dependencies detected. Install them before using ap-hop."
        echo ""
    fi
}

install_script() {
    info "Installing ap-hop to $INSTALL_DIR..."

    if [[ ! -d "$INSTALL_DIR" ]]; then
        mkdir -p "$INSTALL_DIR"
        success "Created directory: $INSTALL_DIR"
    fi

    local temp_file
    temp_file=$(mktemp)

    if curl -fsSL "$SCRIPT_URL" -o "$temp_file"; then
        mv "$temp_file" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
        success "Downloaded and installed $SCRIPT_NAME"
    else
        error "Failed to download ap-hop from $SCRIPT_URL"
        rm -f "$temp_file"
        exit 1
    fi
}

clear_caches() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/ap-hop"

    if [[ -d "$config_dir" ]]; then
        local cache_count
        cache_count=$(find "$config_dir" -name "aps_cache_*" -type f 2>/dev/null | wc -l | xargs)

        if [[ $cache_count -gt 0 ]]; then
            find "$config_dir" -name "aps_cache_*" -type f -delete 2>/dev/null
            success "Cleared $cache_count AP cache(s)"
        fi
    fi
}

setup_path() {
    info "Checking PATH configuration..."

    case ":${PATH}:" in
        *:"$INSTALL_DIR":*)
            success "$INSTALL_DIR is already in PATH"
            echo "0"
            return 0
            ;;
    esac

    warn "$INSTALL_DIR is not in PATH"

    local rc_file=""
    local shell_name="${SHELL##*/}"

    case "$shell_name" in
        bash)
            if [[ -f "$HOME/.bashrc" ]]; then
                rc_file="$HOME/.bashrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                rc_file="$HOME/.bash_profile"
            else
                rc_file="$HOME/.bashrc"
            fi
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            ;;
        *)
            rc_file="$HOME/.profile"
            ;;
    esac

    info "Adding PATH configuration to $rc_file..."

    cat >> "$rc_file" << 'EOF'

# Add ~/.local/bin to PATH if not already present
case ":${PATH}:" in
    *:"$HOME/.local/bin":*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF

    success "Added $INSTALL_DIR to PATH in $rc_file"
    echo ""
    info "Restart your shell or run: source $rc_file"
    echo "1"
    return 0
}

main() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║          ap-hop installer             ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""

    check_dependencies
    echo ""
    install_script
    echo ""
    clear_caches
    echo ""
    local path_modified
    path_modified=$(setup_path)
    echo ""
    success "Installation complete!"

    echo "Generate an API client for the service (cluster) where your APs are over at https://common.cloud.hpe.com/manage-account/api"
    echo "You need the client ID and secret for the initial setup."
    echo ""
    if [[ "$path_modified" == "1" ]]; then
        echo "Next steps:"
        echo "  1. Restart your shell (or source your rc file)"
        echo "  2. Run: ap-hop"
    else
        echo "Next steps:"
        echo "  1. Run: ap-hop"
    fi
    echo ""
}

main "$@"
