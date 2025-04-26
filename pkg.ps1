<#
🧰 Wala - PowerShell Package Assistant
By: You
#>

# -------------------------------------
# 🔧 Utility Function
# -------------------------------------
function Test-Internet {
    Write-Host "`n🌐 Checking Internet Connection..." -ForegroundColor Cyan
    if (Test-Connection -ComputerName google.com -Count 1 -Quiet) {
        Write-Host "✅ Internet is available.`n" -ForegroundColor Green
    } else {
        Write-Host "❌ No internet connection." -ForegroundColor Red
        exit
    }
}

# -------------------------------------
# 🎨 UI Functions
# -------------------------------------
function Show-Header {
    Write-Host "`n🧰 `e[1;36mWala - PowerShell Package Assistant`e[0m`n"
}

function Show-Menu {
    Write-Host "📦 Select a package to simulate install:`n" -ForegroundColor Yellow
    Write-Host "1. Notepad++"
    Write-Host "2. VLC Player"
    Write-Host "3. Firefox"
    Write-Host "4. Exit"
}

# -------------------------------------
# 📦 Install Simulation
# -------------------------------------
function Install-Package {
    param($Name)
    Write-Host "`n⬇️ Installing $Name..." -ForegroundColor Cyan
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity "Installing $Name" -Status "$i% Complete" -PercentComplete $i
        Start-Sleep -Milliseconds 300
    }
    Write-Host "✅ $Name installation simulated successfully!" -ForegroundColor Green
}

# -------------------------------------
# 🚀 Main Flow
# -------------------------------------
Show-Header
Test-Internet
Show-Menu

$choice = Read-Host "👉 Enter your choice (1-4)"
switch ($choice) {
    '1' { Install-Package "Notepad++" }
    '2' { Install-Package "VLC Player" }
    '3' { Install-Package "Firefox" }
    '4' { Write-Host "👋 Exiting..." -ForegroundColor Gray; exit }
    default { Write-Host "❌ Invalid selection." -ForegroundColor Red }
}
