# Panduan Build APK - Buku Budget

## Persiapan Awal

### 1. Install Node.js dan npm
- Download Node.js dari https://nodejs.org/ (pilih versi LTS)
- Install seperti program biasa
- Buka Command Prompt/PowerShell baru, cek dengan perintah:
  ```
  node --version
  npm --version
  ```
- Jika muncul versi angka, berarti install berhasil

### 2. Setup Project Capacitor

Buka folder project ini di Command Prompt/PowerShell, lalu jalankan perintah-perintah berikut:

```bash
# Inisialisasi project Node.js
npm init -y

# Install Capacitor dan dependencies
npm install @capacitor/core @capacitor/cli @capacitor/android
npm install -D @capacitor/assets
```

### 3. Download Library Lokal

Sebelum melanjutkan, jalankan script download-library.bat yang sudah disediakan untuk mengunduh semua library yang dibutuhkan secara lokal.

### 4. Konfigurasi Capacitor

Buat file `capacitor.config.json` dengan isi:

```json
{
  "appId": "com.bukubudget.app",
  "appName": "Buku Budget",
  "webDir": "www",
  "bundledWebRuntime": false
}
```

### 5. Inisialisasi dan Build APK

```bash
# Inisialisasi Capacitor
npx cap init

# Tambah platform Android
npx cap add android

# Copy file web ke folder www
npx cap sync android

# Build APK debug
cd android
./gradlew assembleDebug
```

## Lokasi File APK

Setelah build selesai, file APK akan ada di:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

File ini bisa langsung diinstall di HP Android.

## Update Aplikasi di Masa Depan

Setiap kali ada perubahan pada kode web app (index.html), ikuti langkah berikut:

### Langkah 1: Update Kode Web
Edit file `index.html` sesuai kebutuhan.

### Langkah 2: Copy ke Folder www
```bash
npx cap sync android
```

### Langkah 3: Build APK Baru
```bash
cd android
./gradlew assembleDebug
```

### Langkah 4: Distribusi
- File APK baru ada di: `android/app/build/outputs/apk/debug/app-debug.apk`
- Kirim file APK baru ke tim via WhatsApp
- Minta mereka uninstall versi lama terlebih dahulu
- Install versi baru

## Catatan Penting

1. APK debug tidak bisa di-publish ke Play Store (butuh signing dengan keystore)
2. Untuk testing/internal use, APK debug sudah cukup
3. Setiap perubahan kode harus di-build ulang untuk mendapatkan APK baru
4. APK yang sudah terinstall tidak akan update otomatis
5. Tidak memerlukan internet untuk menjalankan aplikasi setelah diinstall

## Troubleshooting

### Gradle tidak ditemukan
Pastikan Android Studio sudah terinstall, atau set environment variable ANDROID_HOME

### Error saat build
- Pastikan semua dependency sudah terinstall: `npm install`
- Hapus folder `android` dan `www`, lalu ulangi langkah 4-5

### APK tidak terinstall
- Pastikan HP sudah mengaktifkan "Install dari sumber tidak dikenal"
- Uninstall versi lama terlebih dahulu jika ada