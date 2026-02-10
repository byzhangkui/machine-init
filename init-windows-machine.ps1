# 1. Admin Privilege Check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    exit
}

Write-Host "--- Starting AI Dev Environment Setup ---" -ForegroundColor Cyan

# 2. Install Git, Python, and Node.js
$apps = @(
    @{ id = "Git.Git"; name = "Git" },
    @{ id = "Python.Python.3.12"; name = "Python" },
    @{ id = "OpenJS.NodeJS.LTS"; name = "Node.js (LTS)" }
)

foreach ($app in $apps) {
    Write-Host "Installing $($app.name)..." -ForegroundColor Yellow
    winget install --id $app.id -e --source winget --accept-package-agreements --accept-source-agreements --silent
}

# 3. Refresh PATH for the current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# 4. Install Claude Code (Official Script)
Write-Host "Installing Claude Code..." -ForegroundColor Yellow
irm https://claude.ai/install.ps1 | iex

# 5. Install Gemini and Codex via npm
Write-Host "Installing Gemini and Codex CLI..." -ForegroundColor Yellow
npm install -g @google/gemini-cli @openai/codex

# 6. Automatic PATH Fix for .local/bin and npm
Write-Host "Configuring Environment Variables..." -ForegroundColor Cyan
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$npmPrefix = (npm config get prefix).Trim()
$localBin = Join-Path $HOME ".local\bin"

$newPaths = @()
if (Test-Path $npmPrefix) { $newPaths += $npmPrefix }
if (Test-Path $localBin) { $newPaths += $localBin }

foreach ($p in $newPaths) {
    if ($userPath -notlike "*$p*") {
        $userPath = "$userPath;$p"
        Write-Host "Added to PATH: $p" -ForegroundColor Green
    }
}

[System.Environment]::SetEnvironmentVariable("Path", $userPath, "User")

Write-Host "`n--- ALL TOOLS INSTALLED! ---" -ForegroundColor Green
Write-Host "Please RESTART PowerShell to use: claude, gemini, codex" -ForegroundColor Cyan