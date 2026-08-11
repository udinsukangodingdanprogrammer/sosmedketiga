@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title ZShopApps - GitHub Cepat

cls
echo ===============================================
echo        ZSHOPAPPS - GITHUB CEPAT
echo ===============================================
echo.

where git >nul 2>&1
if errorlevel 1 (
  echo [!] Git belum terpasang.
  where winget >nul 2>&1
  if errorlevel 1 (
    echo     Install Git dari: https://git-scm.com/download/win
    pause
    exit /b 1
  )
  choice /C YN /N /M "Install Git sekarang dengan winget? [Y/N]: "
  if errorlevel 2 exit /b 1
  winget install --id Git.Git -e --source winget
  echo.
  echo Tutup lalu jalankan lagi file ini setelah instalasi Git selesai.
  pause
  exit /b 0
)

where gh >nul 2>&1
if errorlevel 1 (
  echo [!] GitHub CLI belum terpasang.
  where winget >nul 2>&1
  if errorlevel 1 (
    echo     Install GitHub CLI dari: https://cli.github.com/
    pause
    exit /b 1
  )
  choice /C YN /N /M "Install GitHub CLI sekarang dengan winget? [Y/N]: "
  if errorlevel 2 exit /b 1
  winget install --id GitHub.cli -e --source winget
  echo.
  echo Tutup lalu jalankan lagi file ini setelah instalasi GitHub CLI selesai.
  pause
  exit /b 0
)

echo [1/5] Cek login GitHub...
gh auth status -h github.com >nul 2>&1
if errorlevel 1 (
  echo Belum login. Browser GitHub akan dibuka.
  gh auth login --hostname github.com --git-protocol https --web
  if errorlevel 1 goto :error
)
gh auth setup-git >nul 2>&1

for /f "usebackq delims=" %%U in (`gh api user --jq ".login"`) do set "GH_USER=%%U"
for /f "usebackq delims=" %%I in (`gh api user --jq ".id"`) do set "GH_ID=%%I"
if not defined GH_USER goto :error

echo [2/5] Siapkan repository lokal...
if not exist .git git init

git config user.name >nul 2>&1
if errorlevel 1 git config user.name "%GH_USER%"
git config user.email >nul 2>&1
if errorlevel 1 git config user.email "%GH_ID%+%GH_USER%@users.noreply.github.com"

git add -A
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"`) do set "NOW=%%T"

git diff --cached --quiet
if errorlevel 1 (
  set "MSG=Update website !NOW!"
  set /p "MSG_INPUT=Pesan commit [!MSG!]: "
  if defined MSG_INPUT set "MSG=!MSG_INPUT!"
  git commit -m "!MSG!"
  if errorlevel 1 goto :error
) else (
  echo Tidak ada perubahan baru untuk di-commit.
)

git branch -M main

echo [3/5] Cek repository GitHub...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
  for %%I in ("%CD%") do set "REPO_NAME=%%~nxI"
  if /I "!REPO_NAME:~-5!"=="-main" set "REPO_NAME=!REPO_NAME:~0,-5!"
  set /p "REPO_INPUT=Nama repository GitHub [!REPO_NAME!]: "
  if defined REPO_INPUT set "REPO_NAME=!REPO_INPUT!"

  echo.
  choice /C PU /N /M "Visibility: [P]ublic / [U]Private: "
  if errorlevel 2 (set "VIS=--private") else (set "VIS=--public")

  gh repo view "%GH_USER%/!REPO_NAME!" >nul 2>&1
  if errorlevel 1 (
    echo [4/5] Membuat repository baru dan push...
    gh repo create "!REPO_NAME!" !VIS! --source=. --remote=origin --push
    if errorlevel 1 goto :error
  ) else (
    echo [4/5] Repository sudah ada. Hubungkan lalu push...
    git remote add origin "https://github.com/%GH_USER%/!REPO_NAME!.git"
    git push -u origin main
    if errorlevel 1 goto :error
  )
) else (
  echo [4/5] Push perubahan ke GitHub...
  git push -u origin main
  if errorlevel 1 goto :error
)

echo [5/5] Selesai.
echo.
echo Repository berhasil diperbarui.
echo Membuka GitHub di browser...
gh repo view --web
exit /b 0

:error
echo.
echo [GAGAL] Proses berhenti. Baca pesan error di atas.
pause
exit /b 1
