# Setup GitHub & Push ke Repository

## Langkah 1: Buat Repository di GitHub

1. Buka https://github.com/new
2. Isi nama repository, contoh: `buku-budget`
3. Pilih **Private** (disarankan) atau **Public**
4. Jangan centang "Add a README file"
5. Klik **Create repository**

## Langkah 2: Push Kode ke GitHub

Buka Command Prompt di folder project ini, jalankan:

```bash
# Inisialisasi git (hanya pertama kali)
git init

# Tambahkan semua file
git add .

# Commit pertama
git commit -m "Initial commit: Buku Budget app"

# Ganti dengan username dan nama repo Anda
git remote add origin https://github.com/USERNAME/buku-budget.git

# Push ke GitHub
git branch -M main
git push -u origin main
```

**Catatan:** Ganti `USERNAME` dengan username GitHub Anda, dan `buku-budget` dengan nama repository yang Anda buat.

## Langkah 3: Aktifkan GitHub Actions

1. Buka repository di GitHub
2. Klik tab **Actions**
3. Anda akan melihat workflow "Build Android APK" sudah terdeteksi
4. Klik **Enable workflow** jika diminta

## Langkah 4: Trigger Build Pertama

### Opsi A: Push perubahan kecil
```bash
# Buat perubahan kecil, misal edit README
echo "# Test" >> README.md

# Push lagi
git add .
git commit -m "Trigger first build"
git push
```

### Opsi B: Manual trigger
1. Buka tab **Actions** di GitHub
2. Klik **Build Android APK** di sidebar kiri
3. Klik tombol **Run workflow** → pilih branch **main** → klik **Run workflow**

## Langkah 5: Download APK

1. Buka tab **Actions** di GitHub
2. Klik workflow run yang sedang berjalan (yang paling atas)
3. Tunggu sampai status **Build Android APK** menjadi hijau ✓
4. Scroll ke bawah, cari bagian **Artifacts**
5. Klik **app-debug-apk** untuk download ZIP
6. Ekstrak ZIP, Anda akan mendapatkan `app-debug.apk`
7. Kirim file APK ke HP Android dan install

## Update di Masa Depan

Setiap kali ada perubahan kode:

```bash
# Edit file seperti biasa (misal index.html)

# Push ke GitHub
git add .
git commit -m "Update: deskripsi perubahan"
git push
```

Tunggu 5-10 menit, lalu download APK baru dari tab Actions.

## Troubleshooting

### Workflow tidak muncul
- Pastikan file `.github/workflows/build-apk.yml` sudah ter-upload ke GitHub
- Cek apakah ada error syntax di file YAML

### Build gagal
- Buka tab Actions, klik run yang gagal
- Lihat log error untuk detail
- Umumnya karena typo di kode atau dependency issue

### APK tidak terinstall
- Pastikan HP mengaktifkan "Install dari sumber tidak dikenal"
- Uninstall versi lama terlebih dahulu jika ada

## Catatan Penting

1. **Branch default:** Workflow hanya trigger otomatis untuk branch `main` atau `master`
2. **Manual trigger:** Bisa juga dijalankan manual dari tab Actions kapan saja
3. **Artifact retention:** APK disimpan 30 hari, lalu otomatis terhapus
4. **Build time:** Sekitar 5-10 menit per build
5. **No local build needed:** Semua proses build di GitHub, tidak perlu Android Studio di laptop