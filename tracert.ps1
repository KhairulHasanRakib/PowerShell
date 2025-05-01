# PowerShell Script: Visual Traceroute
Clear-Host

    Write-Host ""
    Write-Host ""
Write-Host "██╗░░██╗██╗░░██╗░█████╗░██╗██████╗░██╗░░░██╗██╗░░░░░  ██╗░░██╗░█████╗░░██████╗░█████╗░███╗░░██╗" -ForegroundColor Cyan
Write-Host "██║░██╔╝██║░░██║██╔══██╗██║██╔══██╗██║░░░██║██║░░░░░  ██║░░██║██╔══██╗██╔════╝██╔══██╗████╗░██║" -ForegroundColor Cyan
Write-Host "█████═╝░███████║███████║██║██████╔╝██║░░░██║██║░░░░░  ███████║███████║╚█████╗░███████║██╔██╗██║" -ForegroundColor Cyan
Write-Host "██╔═██╗░██╔══██║██╔══██║██║██╔══██╗██║░░░██║██║░░░░░  ██╔══██║██╔══██║░╚═══██╗██╔══██║██║╚████║" -ForegroundColor Cyan
Write-Host "██║░╚██╗██║░░██║██║░░██║██║██║░░██║╚██████╔╝███████╗  ██║░░██║██║░░██║██████╔╝██║░░██║██║░╚███║" -ForegroundColor Cyan
Write-Host "╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚═╝░╚═════╝░╚══════╝  ╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝" -ForegroundColor Cyan
Write-Host ""
    Write-Host "                         🌐Traceroute- Visual CLI Network Debugger🌐"
    Write-Host ""
Write-Host "🌍 Enter a domain or IP to trace:" -ForegroundColor Cyan -NoNewline
$target = Read-Host
Write-Host "🌐 Tracing route to $target...`n" -ForegroundColor Green

# Run tracert and capture output
$tracertOutput = tracert $target 2>&1

# Header
Write-Host "📡 Visual Traceroute" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════════════"
Write-Host ("{0,-6} {1,-25} {2}" -f "Hop", "IP/Domain", "Latency (ms)") -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────"

# Parse and print each hop
foreach ($line in $tracertOutput) {
    if ($line -match "^\s*(\d+)\s+(.+)$") {
        $hopNum = $matches[1]
        $data = $matches[2]

        # Extract IP
        if ($data -match "(\d{1,3}\.){3}\d{1,3}") {
            $ip = $matches[0]
        } else {
            $ip = "???"
        }

        # Extract latency
        $latencies = ($data -split "\s+") -match "ms"
        $latencyStr = if ($latencies) { ($latencies -join " / ") } else { "❌ Timeout" }

        # Print with emojis
        Write-Host ("🔹 {0,-4} {1,-25} {2}" -f $hopNum, $ip, $latencyStr) -ForegroundColor Cyan
    }
}

Write-Host "═══════════════════════════════════════════════"
Write-Host "✅ Trace Complete" -ForegroundColor Green
