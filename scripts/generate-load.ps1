param(
  [string]$BaseUrl = "http://localhost:8080",
  [int]$DurationSeconds = 300,
  [int]$Rps = 5,
  [int]$SlowPercent = 15,
  [int]$ErrorPercent = 5
)

$endTime = (Get-Date).AddSeconds($DurationSeconds)
$rand = New-Object System.Random

Write-Host "Generating load for $DurationSeconds seconds at ~${Rps} rps"

while ((Get-Date) -lt $endTime) {
  $start = Get-Date

  for ($i = 0; $i -lt $Rps; $i++) {
    $roll = $rand.Next(1, 101)
    $path = "/"
    if ($roll -le $ErrorPercent) {
      $path = "/error"
    } elseif ($roll -le ($ErrorPercent + $SlowPercent)) {
      $path = "/slow"
    }

    $url = "$BaseUrl$path"
    try {
      Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 | Out-Null
    } catch {
      # Ignore request errors during load testing
    }
  }

  $elapsed = (Get-Date) - $start
  $sleepMs = [Math]::Max(0, 1000 - $elapsed.TotalMilliseconds)
  Start-Sleep -Milliseconds $sleepMs
}

Write-Host "Load generation complete"
