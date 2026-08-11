@echo off
cd /d "%~dp0"
where gh >nul 2>&1 || (
  echo GitHub CLI belum terpasang. Jalankan GITHUB_CEPAT.bat terlebih dahulu.
  pause
  exit /b 1
)
gh auth status -h github.com >nul 2>&1 || gh auth login --hostname github.com --git-protocol https --web
git remote get-url origin >nul 2>&1 || (
  echo Repository ini belum terhubung ke GitHub. Jalankan GITHUB_CEPAT.bat terlebih dahulu.
  pause
  exit /b 1
)
gh repo view --web
