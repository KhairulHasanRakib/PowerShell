Clear-Host
function Write-Header {
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
}

function Run-Tracert {
    $target = Read-Host "🔎 Enter a domain or IP to trace"
    Write-Host "🚀 Launching visual traceroute to $target`n" -ForegroundColor Green

    $result = tracert $target 2>&1

    Write-Host "╭─────┬───────────────────────────────┬─────────────────────────────╮" -ForegroundColor DarkGray
    Write-Host "│ 🔢  │ 🌐 IP / Domain                │ ⏱️ Latency (ms)             │" -ForegroundColor Cyan
    Write-Host "├─────┼───────────────────────────────┼─────────────────────────────┤" -ForegroundColor DarkGray

    foreach ($line in $result) {
        if ($line -match "^\s*(\d+)\s+(.*)$") {
            $hop = $matches[1]
            $data = $matches[2]

            # Extract IP
            if ($data -match "(\d{1,3}\.){3}\d{1,3}") {
                $ip = $matches[0]
            } else {
                $ip = "🌐 Unknown"
            }

            # Latency
            $latency = ($data -split "\s+") -match "ms"
            $lat = if ($latency) { ($latency -join " / ") } else { "❌ Timeout" }

            $icon = if ($lat -like "*Timeout*") { "💀" } else { "✅" }

            Write-Host ("│ {0,-3} │ {1,-29} │ {2,-26} │" -f $hop, $ip, "$icon $lat") -ForegroundColor Yellow
        }
    }

    Write-Host "╰─────┴───────────────────────────────┴─────────────────────────────╯" -ForegroundColor DarkGray
    Write-Host "`n🎉 Trace Complete!" -ForegroundColor Green
}

# Run It
Write-Header
Run-Tracert
