$ErrorActionPreference = "Stop"

# --- Install extensions ---
Get-Content ./config/vscode/extensions.txt | ForEach-Object {
    code --install-extension $_
}

# --- Resolve VS Code user dir (portable) ---
$VSCODE_USER = "$env:APPDATA\Code\User"

# --- Symlink config (requires admin or dev mode) ---
New-Item -ItemType SymbolicLink `
  -Path "$VSCODE_USER\settings.json" `
  -Target "$PWD\config\vscode\settings.json" -Force

New-Item -ItemType SymbolicLink `
  -Path "$VSCODE_USER\keybindings.json" `
  -Target "$PWD\config\vscode\keybindings.json" -Force

Write-Host "Done ✅ VS Code configured"
