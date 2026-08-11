# ZShopApps / SosmedKetiga

Halaman link sosial media ZShopApps.

## GitHub Cepat (Windows)

1. Ekstrak folder project.
2. Klik dua kali **`GITHUB_CEPAT.bat`**.
3. Jika Git atau GitHub CLI belum tersedia, script akan menawarkan instalasi lewat `winget`.
4. Login GitHub melalui browser jika diminta.
5. Tentukan nama repository dan public/private pada upload pertama.
6. Perubahan berikutnya cukup jalankan **`GITHUB_CEPAT.bat`** lagi. Script akan `add`, `commit`, `push`, lalu membuka repository GitHub.

Untuk hanya membuka repository GitHub yang sudah terhubung, klik **`BUKA_GITHUB.bat`**.

> Jangan simpan password, token, API key, atau file `.env` berisi rahasia ke repository. `.gitignore` sudah disiapkan untuk mengurangi risiko file lokal ikut terunggah.

## File utama

- `Sosmed56.html` — halaman utama.
- `zshopapps.png` — favicon/gambar project.
- `GITHUB_CEPAT.bat` — login/publish/update GitHub dengan cepat.
- `BUKA_GITHUB.bat` — buka repository GitHub dari project ini.
