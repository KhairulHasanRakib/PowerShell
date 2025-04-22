# ==============================
# ⚡ Internet Speed Test Script
# ==============================

# Function to perform Speedtest
function Run-Speedtest {
    $SpeedtestPath = "$env:ProgramFiles\Speedtest\speedtest.exe"
    if (-Not (Test-Path $SpeedtestPath)) {
        Write-Host "⚠️ Speedtest CLI not found! Installing..." -ForegroundColor Yellow
        $InstallerURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
        $DownloadPath = "$env:TEMP\speedtest.zip"
        Invoke-WebRequest -Uri $InstallerURL -OutFile $DownloadPath
        Expand-Archive -Path $DownloadPath -DestinationPath "$env:ProgramFiles\Speedtest" -Force
        if (-Not (Test-Path $SpeedtestPath)) {
            Write-Host "❌ Installation failed. Please install manually." -ForegroundColor Red
            exit
        }
        Write-Host "✅ Speedtest CLI installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "✅ Speedtest CLI found!" -ForegroundColor Green
    }
    Clear-Host
    write-host " ================================= " -ForegroundColor Magenta
    Write-Host " ⚡ Internet Speed Test Script ⚡ " -ForegroundColor Cyan
    write-host " ================================= " -ForegroundColor Magenta

    Write-Host "`n🌐 Running Speedtest..." -ForegroundColor Cyan
    $env:SPEEDTEST_ACCEPT_LICENSE = "true"
    $env:SPEEDTEST_ACCEPT_GDPR = "true"

    $result = & $SpeedtestPath --format=json | ConvertFrom-Json

    Write-Host "---------------------------------" -ForegroundColor Magenta
    Write-Host "      🌐 Speed Test Results 🌐" -ForegroundColor Cyan
    Write-Host "---------------------------------" -ForegroundColor Magenta

    Write-Host ("Download Speed : {0:N2} Mbps" -f ($result.download.bandwidth / 125000)) -ForegroundColor Green
    Write-Host ("Upload Speed   : {0:N2} Mbps" -f ($result.upload.bandwidth / 125000)) -ForegroundColor Blue
    Write-Host ("Latency        : {0:N3} ms" -f $result.ping.latency) -ForegroundColor Yellow
    Write-Host "Server         : $($result.server.name) ($($result.server.country))" -ForegroundColor White
    Write-Host "ISP            : $($result.isp)" -ForegroundColor Magenta
    Write-Host "Timestamp      : $($result.timestamp)" -ForegroundColor Gray

    Write-Host "---------------------------------" -ForegroundColor Magenta
    Write-Host "✅ Test Completed Successfully! 🚀" -ForegroundColor Green
}

# ==============================
# 🔁 Loop for re-running
# ==============================
do {
    Run-Speedtest
    $choice = Read-Host "`nDo you want to run the test again? (Y/N)"
} while ($choice -match "^(Y|y)$")
