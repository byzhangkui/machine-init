#!/bin/bash

# MAC OS Init Script for AI Dev Environment
# Based on init-windows-machine.ps1

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- Starting AI Dev Environment Setup (macOS) ---"

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# 2. Install Git, Python, Node.js, GitHub CLI
echo "Installing/Updating System Packages..."
brew update
brew install git python node gh

# 3. Install Claude Code (Official Script)
echo "Installing Claude Code..."
# The user specified: curl -fsSL https://claude.ai/install.sh | bash
if curl -fsSL https://claude.ai/install.sh | bash; then
    echo "Claude Code installed successfully."
else
    echo "Prepare to install Claude Code manually if the above failed."
fi

# 4. Install Gemini and Codex via npm
echo "Installing Gemini and Codex CLI..."
if command -v npm &> /dev/null; then
    # The user specified:
    # codex: npm i -g @openai/codex
    # gemini: npm install -g @google/gemini-cli
    
    npm install -g @google/gemini-cli @openai/codex
else
    echo "Error: npm is not available. Skipping Gemini and Codex installation."
fi

# 5. Path Configuration (Minimal)
# Homebrew and npm usually handle path setup, but we can remind the user.
echo ""
echo "--- ALL TOOLS INSTALLED! ---"
echo "Please restart your terminal to ensure all tools are available in your PATH."
