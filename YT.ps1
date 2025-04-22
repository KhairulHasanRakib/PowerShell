# ──────────────────────────────────────────────────────────────
#  YT Downloader - PowerShell Script with Auto Setup (yt-dlp + ffmpeg)
# ──────────────────────────────────────────────────────────────

function Ensure-Tool {
    param (
        [string]$Name,
        [string]$WingetID,
        [string]$ChocoID,
        [string]$ScoopID
    )

    if (Get-Command $Name -ErrorAction SilentlyContinue) {
        return $true
    }

    Write-Host "⚙ $Name not found. Attempting to install..." -ForegroundColor Yellow

    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            choco install $ChocoID -y | Out-Null
        } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
            scoop install $ScoopID | Out-Null
        } elseif (Get-Command winget -ErrorAction SilentlyContinue) {
            Start-Process -Wait -NoNewWindow winget -ArgumentList "install --id $WingetID -e -h"
        } else {
            Write-Host "❌ Cannot install $Name automatically. Please install it manually." -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ Installation failed: $_" -ForegroundColor Red
        return $false
    }

    return (Get-Command $Name -ErrorAction SilentlyContinue) -ne $null
}

function Check-And-Install-Dependencies {
    $yt = Ensure-Tool -Name "yt-dlp" -WingetID "yt-dlp.yt-dlp" -ChocoID "yt-dlp" -ScoopID "yt-dlp"
    $ffmpeg = Ensure-Tool -Name "ffmpeg" -WingetID "Gyan.FFmpeg" -ChocoID "ffmpeg" -ScoopID "ffmpeg"

    return ($yt -and $ffmpeg)
}

function Get-DefaultDownloadPath {
    return [Environment]::GetFolderPath("UserProfile") + "\Downloads"
}

function Load-Or-Create-Config {
    $configPath = "$env:USERPROFILE\ytconfig.json"

    if (-not (Test-Path $configPath)) {
        $default = @{ DownloadPath = Get-DefaultDownloadPath; DefaultFormat = "bestvideo+bestaudio" }
        $default | ConvertTo-Json | Set-Content $configPath
    }

    return Get-Content $configPath | ConvertFrom-Json
}

function Get-AvailableFormats {
    param (
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    Write-Host "`n🔍 Fetching available formats for: $URL" -ForegroundColor Cyan

    try {
        $formats = yt-dlp -F $URL | Out-String
        Write-Host "`n📜 Available Formats:`n" -ForegroundColor Yellow
        Write-Host $formats.TrimEnd()
        return $formats
    } catch {
        Write-Host "❌ Failed to fetch formats: $_" -ForegroundColor Red
        return $null
    }
}

function Download-YTVideo {
    param (
        [string]$URL,
        [string]$ChosenFormat,
        [string]$DownloadPath
    )

    Write-Host "`n⏬ Downloading using format ID: $ChosenFormat" -ForegroundColor Cyan

    try {
        yt-dlp -f $ChosenFormat --output "$DownloadPath\%(title)s.%(ext)s" $URL
        Write-Host "`n✅ Download complete!" -ForegroundColor Green
        Write-Host "📁 File saved to: $DownloadPath" -ForegroundColor Magenta
    } catch {
        Write-Host "❌ Download failed: $_" -ForegroundColor Red
    }
}

# ─── Main Execution ────────────────────────────────────────────
Clear-Host
Write-Host "🎬 YouTube Downloader " -ForegroundColor Green
Write-Host "─────────────────────`n"

$config = Load-Or-Create-Config

$videoURL = Read-Host "🔗 Enter YouTube video URL"
if ([string]::IsNullOrWhiteSpace($videoURL)) {
    Write-Host "❌ URL input canceled. Exiting." -ForegroundColor Red
    return
}

if (-not (Check-And-Install-Dependencies)) {
    Write-Host "❌ One or more dependencies could not be installed. Exiting." -ForegroundColor Red
    return
}

$formatsOutput = Get-AvailableFormats -URL $videoURL
if (-not $formatsOutput) { return }

$chosenFormat = Read-Host "`n🎯 Enter format ID (e.g., 137 or 137+140)"
if ([string]::IsNullOrWhiteSpace($chosenFormat)) {
    Write-Host "❌ No format selected. Exiting." -ForegroundColor Red
    return
}

if ($chosenFormat -match "^\d+(\+\d+)?$") {
    Download-YTVideo -URL $videoURL -ChosenFormat $chosenFormat -DownloadPath $config.DownloadPath
} else {
    Write-Host "❌ Invalid format ID. Use the number or combo shown in the list (e.g., 137 or 137+140)." -ForegroundColor Red
}
