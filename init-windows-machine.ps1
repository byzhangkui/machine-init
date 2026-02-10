# IMPORTANT: Before running this script, you may need to set the PowerShell execution policy.
# Open PowerShell as Administrator and run:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# This allows scripts downloaded from the internet (if signed by a trusted publisher)
# and local scripts to run. You can revert this setting after installation if desired.

# 1. Admin Privilege Check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    exit
}

Write-Host "--- Starting AI Dev Environment Setup ---" -ForegroundColor Cyan

# 2. Check for Winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget is not installed or not in PATH. Please install 'App Installer' from the Microsoft Store."
    exit
}

# 3. Install Git, Python, and Node.js
$apps = @(
    @{ id = "Git.Git"; name = "Git" },
    @{ id = "Python.Python.3.12"; name = "Python" },
    @{ id = "OpenJS.NodeJS.LTS"; name = "Node.js (LTS)" },
    @{ id = "GitHub.cli"; name = "GitHub CLI (gh)" }
)

foreach ($app in $apps) {
    Write-Host "Installing $($app.name)..." -ForegroundColor Yellow
    # Using --accept-package-agreements and --accept-source-agreements to avoid interactive prompts
    winget install --id $app.id -e --source winget --accept-package-agreements --accept-source-agreements --silent
}

# 4. Refresh PATH for the current session
# This helps the script find newly installed tools like npm or git immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# 5. Install Claude Code (Official Script)
Write-Host "Installing Claude Code..." -ForegroundColor Yellow
try {
    irm https://claude.ai/install.ps1 | iex
} catch {
    Write-Warning "Failed to install Claude Code. You may need to install it manually."
}

# 6. Install Gemini and Codex via npm
Write-Host "Installing Gemini and Codex CLI..." -ForegroundColor Yellow
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g @google/gemini-cli @openai/codex
} else {
    Write-Warning "npm not found. Skipping Gemini and Codex installation. Please restart your shell and run 'npm install -g @google/gemini-cli @openai/codex' manually."
}

# 7. Automatic PATH Fix for .local/bin and npm
Write-Host "Configuring Environment Variables..." -ForegroundColor Cyan
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$npmPrefix = if (Get-Command npm -ErrorAction SilentlyContinue) { (npm config get prefix).Trim() } else { $null }
$localBin = Join-Path $HOME ".local\bin"

$newPaths = @()
if ($npmPrefix -and (Test-Path $npmPrefix)) { $newPaths += $npmPrefix }
if (Test-Path $localBin) { $newPaths += $localBin }

foreach ($p in $newPaths) {
    if ($userPath -split ";" -notcontains $p) {
        if ($userPath -and -not $userPath.EndsWith(";")) { $userPath += ";" }
        $userPath += $p
        Write-Host "Added to PATH: $p" -ForegroundColor Green
    }
}

[System.Environment]::SetEnvironmentVariable("Path", $userPath, "User")

Write-Host "`n--- ALL TOOLS INSTALLED! ---" -ForegroundColor Green
Write-Host "Please RESTART PowerShell to use: claude, gemini, codex" -ForegroundColor Cyan