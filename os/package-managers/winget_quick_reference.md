# Windows Package Manager (winget) Quick Reference

## What is winget?

Windows Package Manager (winget) is Microsoft's command-line package manager for Windows. It allows you to search, install, upgrade, uninstall, import, and export applications from trusted repositories.

Check version:

```powershell
winget --version
```

Display help:

```powershell
winget --help
```

---

## Search for Packages

Search by application name:

```powershell
winget search vscode
```

Search for Docker:

```powershell
winget search docker
```

---

## View Package Details

Show package information:

```powershell
winget show Docker.DockerDesktop
```

---

## Install Packages

Install using package ID (recommended):

```powershell
winget install --id Docker.DockerDesktop --exact
```

Install Visual Studio Code:

```powershell
winget install --id Microsoft.VisualStudioCode --exact
```

Install silently:

```powershell
winget install --id Git.Git --silent
```

---

## List Installed Packages

```powershell
winget list
```

Filter results:

```powershell
winget list git
```

---

## Check for Available Updates

```powershell
winget upgrade
```

This typically displays:

- Name
- ID
- Installed Version
- Available Version

---

## Upgrade Packages

Upgrade a specific package:

```powershell
winget upgrade --id Docker.DockerDesktop
```

Upgrade all packages:

```powershell
winget upgrade --all
```

Upgrade all packages without prompts:

```powershell
winget upgrade --all --accept-package-agreements --accept-source-agreements
```

Silent upgrade where supported:

```powershell
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
```

Include packages with unknown versions:

```powershell
winget upgrade --all --include-unknown
```

---

## Uninstall Packages

Uninstall by package ID:

```powershell
winget uninstall --id Docker.DockerDesktop
```

---

## Common Package IDs

| Application | Package ID |
|------------|------------|
| Docker Desktop | Docker.DockerDesktop |
| Visual Studio Code | Microsoft.VisualStudioCode |
| PowerShell | Microsoft.PowerShell |
| Google Chrome | Google.Chrome |
| Git | Git.Git |
| Notepad++ | Notepad++.Notepad++ |
| 7-Zip | 7zip.7zip |
| Microsoft Teams | Microsoft.Teams |

---

## Export Installed Applications

```powershell
winget export -o packages.json
```

---

## Import Applications on Another Machine

```powershell
winget import -i packages.json
```

---

## Useful Tips

Always prefer package IDs over display names in scripts.

Example:

```powershell
winget install --id Docker.DockerDesktop --exact
```

Avoid:

```powershell
winget install "Docker Desktop"
```

Package IDs are more stable and less likely to break automation.

---

## Troubleshooting

Refresh package sources:

```powershell
winget source update
```

List configured sources:

```powershell
winget source list
```

Reset sources:

```powershell
winget source reset --force
```
