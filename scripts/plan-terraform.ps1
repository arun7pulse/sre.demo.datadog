param(
  [string]$Env = "dev"
)

$root = Resolve-Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\.."
$envPath = Join-Path $root "infra\environments\$Env"

if (-not (Test-Path $envPath)) {
  Write-Error "Environment '$Env' not found at $envPath"
  exit 1
}

Set-Location $envPath
terraform plan
