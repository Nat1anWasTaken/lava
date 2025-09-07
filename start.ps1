# ------------------------------------------------------------
#  Lava • Launcher (PowerShell)
# ------------------------------------------------------------
#  - Creates a local `plugins/` directory
#  - Checks for Docker availability
#  - Starts services via: docker compose up -d
# ------------------------------------------------------------

$ErrorActionPreference = 'Stop'

if (-not $PSScriptRoot) {
  $PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
}
Set-Location $PSScriptRoot

Write-Host "▶ Lava Launcher" -ForegroundColor Cyan
Write-Host "Preparing your environment…" -ForegroundColor DarkGray
Write-Host

Write-Host "1) Ensure plugins directory" -ForegroundColor White
New-Item -ItemType Directory -Path (Join-Path $PSScriptRoot 'plugins') -Force | Out-Null
Write-Host ("  ✓ Created/verified: {0}" -f (Join-Path $PSScriptRoot 'plugins')) -ForegroundColor Green
Write-Host

Write-Host "2) Check Docker availability" -ForegroundColor White
$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
  Write-Host "  ✖ Docker not found on PATH." -ForegroundColor Red
  Write-Host "  Install Docker: https://docs.docker.com/get-docker/" -ForegroundColor Yellow
  exit 1
}
try {
  $ver = (docker --version) 2>$null
} catch { $ver = $null }
if ($ver) { Write-Host "  ✓ Docker detected: $ver" -ForegroundColor Green } else { Write-Host "  ✓ Docker detected" -ForegroundColor Green }
Write-Host

Write-Host "3) Start services" -ForegroundColor White
Write-Host "  $ docker compose up -d" -ForegroundColor DarkGray
try {
  docker compose up -d
} catch {
  Write-Host "`n  ✖ Failed to start services with 'docker compose'." -ForegroundColor Red
  Write-Host "  Ensure Docker Desktop is running and try again." -ForegroundColor Yellow
  exit 1
}

Write-Host
Write-Host "✓ Services are starting in the background." -ForegroundColor Green
Write-Host "Helpful commands:" -ForegroundColor DarkGray
Write-Host "  • View status:     docker compose ps" -ForegroundColor Gray
Write-Host "  • Follow logs:     docker compose logs -f" -ForegroundColor Gray
Write-Host "  • Stop services:   docker compose down" -ForegroundColor Gray
exit 0
