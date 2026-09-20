# Setup Aplikasi Android - Buku Budget

## File yang Sudah Disiapkan

Semua file konfigurasi sudah dibuat:
- `capacitor.config.json` - Konfigurasi Capacitor
- `package.json` - Dependencies Node.js
- `www/index.html` - Versi web app yang siap di-package
- `download-libs.bat` - Script download library lokal
- `README-APK-BUILD.md` - Panduan lengkap build APK

## Langkah demi Langkah

### 1. Install Node.js
- Download dari https://nodejs.org/ (pilih LTS)
- Install dengan klik Next-Next-Finish
- Buka Command Prompt baru, cek:
  ```
  node --version
  npm --version
  ```

### 2. Setup Project
Buka folder ini di Command Prompt, jalankan:

```bash
# Install dependencies
npm install

# Download library lokal (untuk offline mode)
download-libs.bat
```

### 3. Build APK
```bash
# Inisialisasi Capacitor (hanya pertama kali)
npx cap init

# Tambah platform Android (hanya pertama kali)
npx cap add android

# Build APK
npm run build:android
```

### 4. Hasil
APK akan ada di: `android/app/build/outputs/apk/debug/app-debug.apk`

## Update di Masa Depan

Setiap kali edit `index.html`:
```bash
npm run build:android
```

APK baru akan di-generate otomatis.

## Catatan
- APK ini untuk testing/internal use
- Tidak perlu internet setelah diinstall
- Data tersimpan lokal di HP
- Setiap perubahan harus build ulang APK