@echo off
REM This batch file runs the PowerShell setup script with ExecutionPolicy Bypass
REM and requests Administrative privileges if not already present.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%~dp0init-windows-machine.ps1"' -Verb RunAs"
