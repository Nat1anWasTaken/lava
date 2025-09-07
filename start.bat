@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ------------------------------------------------------------
REM  Lava • Launcher (Windows CMD)
REM ------------------------------------------------------------
REM  - Creates a local `plugins/` directory
REM  - Checks for Docker availability
REM  - Starts services via: docker compose up -d
REM ------------------------------------------------------------

cd /d "%~dp0"

echo ^>^> Lava Launcher
echo     Preparing your environment...
echo.

echo 1^) Ensure plugins directory
mkdir "plugins" 2>nul
echo   [OK] Created/verified: %~dp0plugins
echo.

echo 2^) Check Docker availability
where docker >nul 2>&1
if errorlevel 1 (
  echo   [X] Docker not found on PATH.
  echo       Install Docker: https://docs.docker.com/get-docker/
  exit /b 1
)
for /f "usebackq tokens=*" %%v in (`docker --version 2^>nul`) do set DOCKER_VER=%%v
if defined DOCKER_VER (
  echo   [OK] Docker detected: !DOCKER_VER!
) else (
  echo   [OK] Docker detected.
)
echo.

echo 3^) Ensure stack.env
if not exist "stack.env" (
  echo     'stack.env' not found.
  set /p TOKEN=    Enter TOKEN (the value you just copied from the Discord Developer Portal): 
  (
    echo TOKEN=!TOKEN!
    echo SPOTIFY_CLIENT_ID=
    echo SPOTIFY_CLIENT_SECRET=
    echo API_HOST=
    echo API_PORT=
    echo.
    echo # LOGGING_LEVEL_ROOT=INFO
    echo # LOGGING_LEVEL_LAVALINK=INFO
  ) > "stack.env"
  echo   [OK] Created stack.env
) else (
  echo   [OK] Found stack.env
)
echo.

echo 4^) Start services
echo     $ docker compose up -d
docker compose up -d
if errorlevel 1 (
  echo.
  echo   [X] Failed to start services with 'docker compose'.
  echo       Ensure Docker Desktop is running and try again.
  exit /b 1
)

echo.
echo [OK] Services are starting in the background.
echo     Helpful commands:
echo       • View status:     docker compose ps
echo       • Follow logs:     docker compose logs -f
echo       • Stop services:   docker compose down
exit /b 0
