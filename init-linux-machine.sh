#!/bin/bash

# Linux Init Script for AI Dev Environment
# Based on init-mac-machine.sh and init-windows-machine.ps1

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- Starting AI Dev Environment Setup (Linux) ---"

# 1. Root/Sudo Check
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges for package installation."
    echo "Re-running with sudo..."
    exec sudo bash "$0" "$@"
fi

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

# 2. Install Git, Python, Node.js, GitHub CLI
echo "Installing/Updating System Packages..."

case $PKG_MANAGER in
    apt)
        apt-get update

        # Add GitHub CLI official repository
        if ! command -v gh &> /dev/null; then
            apt-get install -y curl
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
                | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            apt-get update
        fi

        # Add NodeSource repository for Node.js LTS
        if ! command -v node &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        fi

        apt-get install -y git python3 python3-pip nodejs gh
        ;;
    dnf)
        dnf install -y dnf-plugins-core
        dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

        # Add NodeSource repository for Node.js LTS
        if ! command -v node &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
        fi

        dnf install -y git python3 python3-pip nodejs gh
        ;;
    yum)
        yum install -y yum-utils
        yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

        # Add NodeSource repository for Node.js LTS
        if ! command -v node &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
        fi

        yum install -y git python3 python3-pip nodejs gh
        ;;
    pacman)
        pacman -Syu --noconfirm git python python-pip nodejs npm github-cli
        ;;
esac

# 3. Install Claude Code (Official Script)
echo "Installing Claude Code..."
if curl -fsSL https://claude.ai/install.sh | bash; then
    echo "Claude Code installed successfully."
else
    echo "Prepare to install Claude Code manually if the above failed."
fi

# 4. Install Gemini and Codex via npm
echo "Installing Gemini and Codex CLI..."
if command -v npm &> /dev/null; then
    npm install -g @google/gemini-cli @openai/codex
else
    echo "Error: npm is not available. Skipping Gemini and Codex installation."
fi

# 5. PATH Configuration
echo ""
echo "--- ALL TOOLS INSTALLED! ---"
echo "Please restart your terminal to ensure all tools are available in your PATH."
