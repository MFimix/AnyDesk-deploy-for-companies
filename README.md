<div align="center">

```
 █████╗ ███╗   ██╗██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗    ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗
██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔════╝██║ ██╔╝    ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝
███████║██╔██╗ ██║ ╚████╔╝ ██║  ██║█████╗  ███████╗█████╔╝     ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝ 
██╔══██║██║╚██╗██║  ╚██╔╝  ██║  ██║██╔══╝  ╚════██║██╔═██╗     ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝  
██║  ██║██║ ╚████║   ██║   ██████╔╝███████╗███████║██║  ██╗    ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║   
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝  
```

# AnyDesk Deploy

**A transparent, lightweight Windows Batch script for streamlined and reproducible AnyDesk deployments.**

[![Platform](https://img.shields.io/badge/platform-Windows-0078D6?style=flat-square&logo=windows)](https://www.microsoft.com/windows)
[![Language](https://img.shields.io/badge/language-Batch%20Script-4D4D4D?style=flat-square&logo=windowsterminal)](https://en.wikipedia.org/wiki/Batch_file)
[![License](https://img.shields.io/badge/license-MIT-22C55E?style=flat-square)](LICENSE)
[![Admin Required](https://img.shields.io/badge/requires-Administrator-EF4444?style=flat-square&logo=shield)](https://learn.microsoft.com/en-us/windows/security/identity-protection/user-account-control/user-account-control-overview)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-8B5CF6?style=flat-square)](CONTRIBUTING.md)

*Designed for IT administrators, system maintainers, and home lab enthusiasts.*

</div>

---

> [!WARNING]
> **Responsible Use Only.** This tool is intended exclusively for managing devices you own, lease, or are explicitly authorized to administer. Always obtain consent before enabling remote access. See [Responsible Use](#️-responsible-use) for full details.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Configuration](#️-configuration)
- [Quick Start](#-quick-start)
- [Advanced Customization](#-advanced-customization)
- [Security Best Practices](#-security-best-practices)
- [Enterprise Environments](#-enterprise-environments)
- [Responsible Use](#️-responsible-use)

---

## 🔍 Overview

**AnyDesk Deploy** is a pure Batch script that automates the installation and configuration of [AnyDesk](https://anydesk.com) on Windows machines. No compiled wrappers, no hidden binaries — just clean, readable `.bat` code you can audit line by line.

Whether you're rolling out remote access across a fleet of corporate workstations or setting up a personal home lab, this script eliminates repetitive manual setup while giving you full control over every configuration detail.

---

## 🚀 Features

| Feature | Description |
|---|---|
| **Silent Installation** | Deploys AnyDesk without disruptive UI wizards — zero click-through |
| **Pre-configured Environment** | Injects your settings automatically on first run |
| **Unattended Access** | Optional password-based access for headless and remote machines |
| **100% Transparent** | Plain Batch — every line is readable and auditable |
| **No Hidden Binaries** | No compiled executables or obfuscated code, ever |

---

## ⚙️ Configuration

Before running the script, open `deploy.bat` in any text editor and update the following variables:

```batch
:: ─────────────────────────────────────────────────────────
::  REQUIRED CONFIGURATION — Update these before executing
:: ─────────────────────────────────────────────────────────

set "EXFIL_URL=[PUT_YOUR_PIPEDREAM_LINK_HERE]"
set "PASSWORD=[PUT_YOUR_PASSWORD_HERE]"
```

| Variable | Description | Example |
|---|---|---|
| `EXFIL_URL` | Your pipdream link to view and verify `IPs` and `Passwords` of the recently deployed device  | `https://pipedream.com` |
| `PASSWORD` | Password for unattended/headless access | `MyStr0ng!Pass` |

> [!TIP]
> Never hardcode real passwords if you plan to share or version-control this file. Use environment variables or a secret vault instead — see [Security Best Practices](#-security-best-practices).

---

## ⚡ Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/MFimix/anydesk-deploy.git
cd anydesk-deploy
```

### 2. Configure the Script

Open `DEPLOY.bat` and fill in your values:

```batch
set "EXFIL_URL=[PUT_YOUR_PIPEDREAM_LINK_HERE]"
set "PASSWORD=[PUT_YOUR_PASSWORD_HERE]"
```
### 3. Put the files on the flash drive

Put the configured `DEPLOY.bat` file on the flash drive or the dedicated folder on it, and add `Client_IDs.txt` and `AnyDesk.exe` to the same directory.

### 4. Run as Administrator on the targeted device.

> Administrative privileges are required to modify system services and installation directories.

Right-click `DEPLOY.bat` → **Run as administrator**

### 5. Verify the Deployment

Once complete, confirm that the ID and the password of the device appeared on PipeDream.

## 🛠️ Advanced Customization

The script exposes several optional configuration blocks you can modify to fit your environment:

```
📁 deploy.bat
├── 📌 Installation Path      — Change the local target directory
├── 🖥️  UI Footprint           — Toggle desktop shortcuts & Start Menu entries
└── 🔄 Boot Behavior          — Enable or disable automatic startup on boot
```

Each block is clearly commented inline — look for the `:: [OPTIONAL]` markers throughout the file.

---

## 🔐 Security Best Practices

Remote access tooling demands a high security standard. Follow these guidelines:

**🔑 Enforce Strong Credentials**
Never use default, short, or guessable passwords for unattended access. Use a password manager to generate strong, unique strings.

**🙈 Protect Your Secrets**
Do not commit plain-text passwords to any public (or private) repository. Instead:
- Use OS-level environment variables
- Use an enterprise secret vault (HashiCorp Vault, Azure Key Vault, AWS Secrets Manager)
- Use a `.env` file added to `.gitignore`

**🛡️ Harden Your Network**
Restrict incoming remote access traffic at the firewall level. Prefer VPN-gated access over open-internet exposure.

**📋 Audit Regularly**
Periodically review active AnyDesk sessions and connection logs. Revoke credentials that are no longer needed.

---

## 🏢 Enterprise Environments

For large-scale or multi-seat deployments, consider graduating beyond individual scripts to enterprise-grade orchestration:

| Method | Details |
|---|---|
| **AnyDesk Custom Client** | Use the official AnyDesk Management Console and custom client generator for centralized control |
| **Microsoft Intune / UEM** | Package and push the deployment via Intune, SCCM, or any compatible MDM solution |
| **Group Policy (GPO)** | Distribute via Active Directory Group Policy for domain-joined machine fleets |

---

## ⚖️ Responsible Use

This project exists to make *legitimate* administration easier, not to enable unauthorized access.

✅ **Permitted use cases:**
- Deploying to devices within your own organization
- Setting up access on personal machines or home labs
- Managing devices you own, lease, or are contractually authorized to administer

❌ **Strictly prohibited:**
- Deploying without the user's knowledge or consent
- Concealing remote access footprints or configurations
- Storing or transmitting credentials insecurely

> **Always obtain explicit, informed consent before enabling remote access to any device.**

---

<div align="center">

Made with 🖤 for the IT community · [Open an Issue](../../issues) · [Submit a PR](../../pulls)

</div>
