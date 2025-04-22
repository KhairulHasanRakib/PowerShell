# ================================
# 🎵 YouTube MP3 Downloader Script
# ================================

function Download-YTVideo {
    param (
        [string]$URL
    )

    # Check if yt-dlp is installed
    if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
        Write-Host "`n❌ yt-dlp is not installed! Please install it first." -ForegroundColor Red
        return
    }

    # Display checking formats message
    Write-Host "`n🔍 Checking available audio formats..." -ForegroundColor Cyan

    # Fetch available formats
    $formats = yt-dlp -F $URL 2>&1

    # Get best available audio format
    $bestAudioFormat = $formats | Where-Object { $_ -match "audio" } | Select-Object -Last 1

    if (-not $bestAudioFormat) {
        Write-Host "`n❌ No audio format available for this video!" -ForegroundColor Red
        return
    }

    # Extract format code (first item in split)
    $formatCode = ($bestAudioFormat -split '\s+')[0]

    # Set download path
    $downloadPath = "$env:USERPROFILE\Downloads"

    # Start downloading
    Write-Host "`n🔄 Downloading audio in MP3 format..." -ForegroundColor Yellow
    yt-dlp -f $formatCode --extract-audio --audio-format mp3 $URL --output "$downloadPath\%(title)s.%(ext)s"

    # Completion message
    Write-Host "`n✅ Download complete!" -ForegroundColor Green
    Write-Host "📁 Saved to: $downloadPath`n" -ForegroundColor Gray
}

# Ask for YouTube URL
Write-Host "🎬 YouTube MP3 Downloader" -ForegroundColor Magenta
Write-Host "=========================" -ForegroundColor Magenta
$videoURL = Read-Host "`n🔗 Enter YouTube Video URL"

# Start download
Download-YTVideo -URL $videoURL
