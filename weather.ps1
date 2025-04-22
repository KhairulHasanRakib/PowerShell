Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Weather Dashboard"
$form.Width = 500
$form.Height = 400
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = "White"

# Font Styles
$fontTitle = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontText = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)

# Create Labels
$labels = @()
$labelNames = @("Day:", "Date:", "Time:", "Temperature:", "Wind Speed:", "Humidity:")
foreach ($i in 0..($labelNames.Length - 1)) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "$($labelNames[$i])"
    $lbl.Font = $fontText
    $lbl.AutoSize = $true
    $lbl.Location = [System.Drawing.Point]::new(30, 60 + ($i * 40))  # ✅ FIXED
    $form.Controls.Add($lbl)
    $labels += $lbl
}

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Live Weather Dashboard"
$titleLabel.Font = $fontTitle
$titleLabel.AutoSize = $true
$titleLabel.ForeColor = "DarkBlue"
$titleLabel.Location = [System.Drawing.Point]::new(90, 20)
$form.Controls.Add($titleLabel)

# Function to Get Weather Data
function Get-WeatherData {
    try {
        $uri = "https://api.open-meteo.com/v1/forecast?latitude=23.81&longitude=90.41&current=temperature_2m,wind_speed_10m,relative_humidity_2m"
        return Invoke-RestMethod -Uri $uri -TimeoutSec 5
    } catch {
        return $null
    }
}

# Update Function
function Update-Data {
    $weatherData = Get-WeatherData
    if ($weatherData -ne $null) {
        $day = (Get-Date).DayOfWeek
        $date = (Get-Date -Format "dd MMM yyyy")
        $time = (Get-Date -Format "hh:mm:ss tt")
        $temperature = $weatherData.current.temperature_2m
        $windSpeed = $weatherData.current.wind_speed_10m
        $humidity = $weatherData.current.relative_humidity_2m

        $labels[0].Text = "Day: $day"
        $labels[1].Text = "Date: $date"
        $labels[2].Text = "Time: $time"
        $labels[3].Text = "Temperature: $temperature°C"
        $labels[4].Text = "Wind Speed: $windSpeed m/s"
        $labels[5].Text = "Humidity: $humidity%"
    } else {
        foreach ($lbl in $labels) {
            $lbl.Text = "Error loading data..."
        }
    }
}

# Timer to Auto Refresh
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000 # 1 second
$timer.Add_Tick({ Update-Data })
$timer.Start()

# Show the Form
Update-Data
$form.ShowDialog()
