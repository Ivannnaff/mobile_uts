# 🛠️ Panduan Setup — MADHANG

Langkah demi langkah untuk memasang Flutter, membuat project **madhang**, menempel kode, dan menjalankannya. Kode lengkap ada di `madhang_app.md` (bagian *Source Code*).

**Perkiraan waktu:** 30–60 menit untuk pertama kali (kebanyakan mengunduh), sekitar 5 menit jika Flutter sudah terpasang.

---

## 1. Prasyarat

| Kebutuhan | Keterangan |
|---|---|
| Sistem operasi | Windows 10/11, macOS, atau Linux (build iOS memerlukan macOS) |
| Ruang disk | Sekitar 10 GB (Flutter, Android Studio, emulator) |
| Internet | Untuk unduhan dan untuk memuat foto (`Image.network`) |
| Flutter SDK | Versi 3.10 atau lebih baru |
| Editor | Android Studio atau VS Code |
| Perangkat uji | Emulator Android, ponsel Android asli, atau Chrome |

---

## 2. Pasang Flutter SDK

1. Buka panduan resmi: <https://docs.flutter.dev/get-started/install> dan pilih sistem operasimu.
2. Unduh dan ekstrak SDK ke folder **tanpa spasi**, misalnya `C:\dev\flutter` (Windows) atau `~/development/flutter` (macOS/Linux).
3. Tambahkan folder `bin` milik Flutter ke **PATH**:

| OS | Yang ditambahkan |
|---|---|
| Windows | `C:\dev\flutter\bin` lewat *System Properties → Environment Variables → Path → New* |
| macOS / Linux | Tambahkan `export PATH="$PATH:$HOME/development/flutter/bin"` ke `~/.zshrc` atau `~/.bashrc`, lalu muat ulang filenya |

4. Buka terminal **baru** dan cek:

```bash
flutter --version
```

---

## 3. Pasang Android Studio dan Android SDK

1. Unduh Android Studio dari <https://developer.android.com/studio> dan pasang dengan pilihan bawaan.
2. Buka **Settings → Plugins**, cari **Flutter**, lalu pasang (plugin Dart ikut terpasang). Mulai ulang IDE.
3. Buka **Settings → Languages & Frameworks → Android SDK → SDK Tools**, lalu centang:
   - Android SDK Command-line Tools (latest)
   - Android SDK Build-Tools
   - Android Emulator
   - Android SDK Platform-Tools
4. Setujui lisensi Android:

```bash
flutter doctor --android-licenses
```

Ketik `y` pada setiap pertanyaan.

> **Memakai VS Code?** Pasang ekstensi **Flutter** dari panel Extensions (Dart ikut terpasang). Kamu tetap membutuhkan SDK dan emulator dari Android Studio.

---

## 4. Verifikasi Lingkungan

```bash
flutter doctor
```

Yang diharapkan: tanda ✓ hijau di **Flutter**, **Android toolchain**, dan **editor**. Entri Xcode dan Visual Studio boleh tidak tercentang kecuali kamu menargetkan iOS atau desktop Windows.

---

## 5. Buat Project

```bash
flutter create madhang
cd madhang
```

Buka folder `madhang` di editormu. Struktur penting:

```
madhang/
├── android/
├── ios/
├── lib/
│   └── main.dart            ← satu-satunya file yang wajib diubah
├── test/
│   └── widget_test.dart     ← lihat langkah 6.2
├── assets/                  ← opsional, untuk foto WebP lokal (bagian 9)
│   └── images/
└── pubspec.yaml
```

---

## 6. Tempel Kode

### 6.1 `lib/main.dart`
1. Buka `lib/main.dart` dan **hapus seluruh isinya**.
2. Salin seluruh blok kode Dart dari bagian **Source Code** di `madhang_app.md`.
3. Tempel ke `lib/main.dart`, lalu simpan.

Pemeriksaan cepat: file diawali `import 'package:flutter/material.dart';` dan `import 'package:flutter/services.dart';`, dan mendefinisikan `SplashPage`, `LoginPage`, `PreferencePage`, `MainShell`, `RestaurantPage`, `CheckoutPage`, dan `SuccessPage`.

### 6.2 `test/widget_test.dart`
File uji bawaan merujuk ke aplikasi counter dan akan gagal dikompilasi. Ganti seluruh isinya dengan:

```dart
void main() {}
```

(atau hapus file tersebut).

### 6.3 `pubspec.yaml`
Aplikasi **tidak memerlukan paket tambahan**. Biarkan dependensi bawaan. Ubah hanya bila memakai foto lokal (bagian 9).

---

## 7. Jalankan Aplikasi

### 7.1 Pilih perangkat

| Pilihan | Cara |
|---|---|
| **Emulator Android** | Android Studio → **Device Manager** → **Create Device** → pilih ponsel (mis. Pixel 7) → unduh system image → tekan ▶ |
| **Ponsel Android asli** | Pengaturan → Tentang ponsel → ketuk **Nomor build** 7 kali → Opsi pengembang → aktifkan **USB debugging** → sambungkan USB dan setujui prompt |
| **Chrome** | Tanpa persiapan; Flutter mendeteksinya otomatis |

### 7.2 Perintah

```bash
flutter pub get
flutter devices
flutter run
```

Untuk memilih perangkat tertentu: `flutter run -d chrome` atau `flutter run -d <id-perangkat>`.

Tombol saat aplikasi berjalan di terminal:

| Tombol | Fungsi |
|---|---|
| `r` | Hot reload |
| `R` | Hot restart |
| `q` | Keluar |

### 7.3 Cek kualitas kode (disarankan)

```bash
flutter analyze
```

Yang diharapkan: tidak ada error. Peringatan gaya (mis. `prefer_const_constructors`) boleh diabaikan.

---

## 8. Uji Alur Aplikasi

| # | Aksi | Hasil yang diharapkan |
|---|---|---|
| 1 | Buka aplikasi | Splash gelap dengan 4 foto dan logo **MADHANG** |
| 2 | Ketuk **Mulai** | Halaman login |
| 3 | Ketuk **Masuk** | Halaman "Kamu suka makan apa?"; memilih kotak memberi border oranye dan centang |
| 4 | Ketuk **Lewati** (atau tombol panah) | Beranda dengan bottom navigation; tombol back **tidak** kembali ke login |
| 5 | Ketuk keempat tab | Beranda, Favorit, Pesanan, Profil menampilkan isi |
| 6 | Ketuk kartu restoran | Detail restoran dengan header foto dan daftar menu |
| 7 | Ketuk **+** pada menu | Muncul kontrol jumlah; tombol bawah menampilkan jumlah item dan total |
| 8 | Ketuk **Lihat Keranjang** | Checkout dengan subtotal, ongkos kirim, dan total |
| 9 | Ketuk tombol back | Kembali ke daftar menu (`pop`) |
| 10 | Ketuk **Pesan Sekarang** | Layar sukses oranye dengan nomor pesanan |
| 11 | Ketuk **Kembali ke Beranda** | Kembali ke Beranda (`popUntil`) |
| 12 | Profil → **Keluar** | Kembali ke splash; riwayat navigasi dibersihkan |

Jika langkah 1–12 lolos, ketujuh route dan navigasi `push()`/`pop()` bekerja.

---

## 9. Foto dalam Format WebP

### 9.1 Foto dari jaringan (default, sudah WebP)
Fungsi `img()` di `main.dart` sudah meminta WebP:

```dart
String img(String id) =>
    'https://images.unsplash.com/photo-$id?fm=webp&fit=crop&w=700&q=70';
```

Pastikan parameter `fm=webp` tetap ada jika kamu mengganti ID atau URL foto.

### 9.2 (Opsional) Foto lokal WebP dengan `Image.asset`

**Langkah 1.** Konversi foto ke WebP (pilih salah satu):

```bash
# cwebp (paket libwebp), ukuran lebar 700 px
cwebp -q 75 -resize 700 0 nasi.jpg -o nasi.webp

# ImageMagick
magick nasi.jpg -resize 700x -quality 75 nasi.webp

# Konversi massal (macOS/Linux)
for f in *.jpg; do cwebp -q 75 -resize 700 0 "$f" -o "${f%.jpg}.webp"; done
```

Atau pakai alat daring seperti Squoosh (<https://squoosh.app>).

**Langkah 2.** Taruh file di `assets/images/` (mis. `assets/images/nasi.webp`).

**Langkah 3.** Daftarkan folder di `pubspec.yaml`, di bawah `flutter:` dengan indentasi **2 spasi**:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
```

**Langkah 4.** Jalankan `flutter pub get`.

**Langkah 5.** Di `main.dart`:

```dart
// Ganti img() agar menunjuk ke aset lokal
String img(String name) => 'assets/images/$name.webp';
```

Di widget `Photo`, ganti `Image.network(url, ...)` dengan:

```dart
Image.asset(
  url,
  width: w,
  height: h,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stack) => Container(
    width: w,
    height: h,
    color: const Color(0xFFFFE3DA),
    child: const Icon(Icons.restaurant, color: kOrange),
  ),
)
```

Dan ganti setiap `NetworkImage(...)` pada `DecorationImage` menjadi `AssetImage(...)`. Ubah juga argumen `img('1504674900247-...')` menjadi nama berkas, misalnya `img('nasi')`.

**Langkah 6.** Hentikan dan jalankan ulang aplikasi (hot reload tidak membaca aset baru).

### 9.3 Memeriksa format WebP
- Jaringan: jalankan `flutter run --profile`, buka **DevTools → Network**, dan pastikan header `content-type` bernilai `image/webp`.
- Lokal: pastikan semua file di `assets/images/` berakhiran `.webp`.

---

## 10. Build APK Rilis (Android)

Build debug sudah punya akses internet. Untuk build rilis, tambahkan izin berikut di `android/app/src/main/AndroidManifest.xml`, di dalam `<manifest>` dan **di atas** `<application ...>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Lalu:

```bash
flutter build apk --analyze-size
```

Hasil: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 11. Pemecahan Masalah

| Masalah | Solusi |
|---|---|
| `flutter` tidak dikenali | `flutter/bin` belum ada di PATH. Tambahkan, lalu buka terminal baru. |
| `Android license status unknown` | Jalankan `flutter doctor --android-licenses` dan setujui semuanya. |
| `cmdline-tools component is missing` | Android Studio → SDK Manager → SDK Tools → pasang **Android SDK Command-line Tools**. |
| Tidak ada perangkat | Jalankan emulator, sambungkan ponsel dengan USB debugging, atau `flutter run -d chrome`. |
| Error `super.key` atau `useMaterial3` | Flutter terlalu lama. Jalankan `flutter upgrade`. |
| Error kompilasi di `test/widget_test.dart` | Ganti isinya dengan `void main() {}` (langkah 6.2). |
| Foto menampilkan ikon, bukan gambar | Tidak ada internet atau tautan foto sudah mati. Ganti ID foto di `restaurants` dan `categories`, atau pakai foto lokal (bagian 9.2). |
| Foto tidak muncul di Chrome | Host gambar bisa memblokir permintaan browser. Uji di emulator atau ponsel. |
| `Unable to load asset` | Folder aset belum terdaftar di `pubspec.yaml`, indentasi salah, atau nama berkas tidak cocok. Jalankan ulang aplikasi setelah `flutter pub get`. |
| Layout berubah di layar besar | Normal: lebar dibatasi 430 dp agar mirip ponsel. |
| Build gagal setelah mengubah berkas | Jalankan `flutter clean`, `flutter pub get`, lalu `flutter run`. |
| Emulator sangat lambat | Aktifkan akselerasi perangkat keras, atau pakai ponsel asli. |

---

## 12. Daftar Periksa Akhir

- [ ] `flutter doctor` tanpa error kritis
- [ ] Project dibuat dengan `flutter create madhang`
- [ ] `test/widget_test.dart` diganti atau dihapus
- [ ] `lib/main.dart` berisi kode MADHANG
- [ ] `flutter analyze` tanpa error
- [ ] Ke-12 langkah uji di bagian 8 lolos
- [ ] Foto berformat WebP (`fm=webp` atau berkas `.webp`)
- [ ] (Opsional) APK rilis berhasil dibuat

## 13. Perintah yang Berguna

```bash
flutter doctor          # cek lingkungan
flutter devices         # daftar perangkat
flutter pub get         # ambil paket / muat ulang aset
flutter run             # jalankan aplikasi
flutter run --profile   # mode profil untuk uji performa
flutter analyze         # analisis kode
flutter clean           # hapus berkas build
flutter upgrade         # perbarui Flutter
flutter build apk       # build APK rilis
```
