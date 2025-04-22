function Set-Reminder {
    param (
        [string]$Message,
        [int]$IntervalMinutes
    )

    while ($true) {
        # Show a Windows Toast Notification
        $app = New-Object -ComObject WScript.Shell
        $app.Popup("$Message", 3, "⏰ Reminder", 64)

        # Wait for the next interval
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
}

# Get Reminder Details
$reminderText = Read-Host "Enter your reminder message"
$reminderTime = Read-Host "Enter time interval (in minutes)"

# Start Reminder Loop
Set-Reminder -Message $reminderText -IntervalMinutes $reminderTime
