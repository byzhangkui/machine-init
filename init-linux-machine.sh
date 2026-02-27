#!/bin/bash

# Linux Init Script for AI Dev Environment
# Based on init-mac-machine.sh and init-windows-machine.ps1

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- Starting AI Dev Environment Setup (Linux) ---"

# Record the real user (before sudo) for installing user-space tools later
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# Detect the package manager
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Error: No supported package manager found (apt, dnf, yum, pacman)."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"

# ========== Phase 1: System packages (requires root) ==========
install_system_packages() {
    echo "Installing/Updating System Packages..."

    case $PKG_MANAGER in
        apt)
            sudo apt-get update

            # Add GitHub CLI official repository
            if ! command -v gh &> /dev/null; then
                sudo apt-get install -y curl
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
                    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt-get update
            fi

            # Add NodeSource repository for Node.js LTS
            if ! command -v node &> /dev/null; then
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
            fi

            sudo apt-get install -y git python3 python3-pip nodejs gh
            ;;
        dnf)
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

            # Add NodeSource repository for Node.js LTS
            if ! command -v node &> /dev/null; then
                curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            fi

            sudo dnf install -y git python3 python3-pip nodejs gh
            ;;
        yum)
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

            # Add NodeSource repository for Node.js LTS
            if ! command -v node &> /dev/null; then
                curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            fi

            sudo yum install -y git python3 python3-pip nodejs gh
            ;;
        pacman)
            sudo pacman -Syu --noconfirm git python python-pip nodejs npm github-cli
            ;;
    esac
}

# ========== Phase 2: User-space tools (runs as the real user) ==========
install_user_tools() {
    # Install Claude Code (Official Script)
    echo "Installing Claude Code..."
    if curl -fsSL https://claude.ai/install.sh | bash; then
        echo "Claude Code installed successfully."
    else
        echo "Prepare to install Claude Code manually if the above failed."
    fi

    # Install Gemini and Codex via npm
    echo "Installing Gemini and Codex CLI..."
    if command -v npm &> /dev/null; then
        npm install -g @google/gemini-cli @openai/codex
    else
        echo "Error: npm is not available. Skipping Gemini and Codex installation."
    fi
}

# ========== Execute ==========
install_system_packages

# Run user-space tool installation as the real user (not root)
if [[ $EUID -eq 0 && -n "$SUDO_USER" ]]; then
    echo "Switching to user '$REAL_USER' for user-space tool installation..."
    sudo -u "$REAL_USER" bash -c "$(declare -f install_user_tools); install_user_tools"
else
    install_user_tools
fi

echo ""
echo "--- ALL TOOLS INSTALLED! ---"
echo "Please restart your terminal to ensure all tools are available in your PATH."
