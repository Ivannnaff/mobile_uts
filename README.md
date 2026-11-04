# MADHANG — Aplikasi Menu Dine-In

Aplikasi mobile pemesanan makanan di tempat (*dine-in*) berbasis **Flutter** dengan tampilan yang bersih, modern, dan mudah digunakan. Aplikasi ini dibuat untuk memenuhi tugas UTS mata kuliah Pemrograman Mobile.

## Deskripsi

MADHANG adalah aplikasi yang menampilkan daftar menu restoran untuk pelanggan yang sedang makan di tempat. Pelanggan dapat melihat menu berdasarkan kategori (Makanan, Snack, Minuman), melihat detail setiap menu, dan mengakses informasi restoran seperti kontak, lokasi, serta cara pemesanan.

## Fitur

- Masuk dengan nomor meja dan nama pelanggan
- Daftar menu dengan filter kategori (Makanan, Snack, Minuman)
- Detail menu lengkap (foto, harga, deskripsi, porsi, estimasi penyajian)
- Daftar menu favorit
- Halaman tentang aplikasi
- Halaman kontak dan jam operasional
- Halaman lokasi restoran
- Halaman bantuan dan metode pembayaran

## Teknologi

- Flutter (Dart)
- Material 3
- Gambar format WebP melalui `Image.network`

## Struktur Folder

```
lib/
├── main.dart                     # Entry point aplikasi & konfigurasi tema
├── core/
│   └── constants.dart            # Warna, format Rupiah, helper navigasi
├── models/
│   └── food_item.dart            # Model data menu
├── widgets/
│   └── custom_widgets.dart       # Komponen UI reusable
└── pages/
    ├── login_page.dart           # Halaman masuk & input nomor meja
    ├── main_shell.dart           # Halaman utama (Menu & Favorit)
    ├── detail_menu_page.dart     # Detail menu
    ├── about_page.dart           # Tentang aplikasi
    ├── contact_page.dart         # Kontak & jam operasional
    ├── location_page.dart        # Lokasi restoran
    └── help_page.dart            # Bantuan & metode pembayaran
```

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terinstal.
2. Clone repository:
   ```bash
   git clone https://github.com/Ivannnaff/mobile_uts.git
   cd mobile_uts
   ```
3. Ambil dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run -d chrome
   ```

## Screenshot

| Halaman Login | Halaman Menu |
|:---:|:---:|
| ![Login](screenshots/login.png) | ![Menu](screenshots/menu.png) |

| Detail Menu | Menu Favorit |
|:---:|:---:|
| ![Detail](screenshots/detail.png) | ![Favorit](screenshots/favorit.png) |

| Tentang Aplikasi | Bantuan & Pembayaran |
|:---:|:---:|
| ![Tentang](screenshots/about.png) | ![Bantuan](screenshots/help.png) |
