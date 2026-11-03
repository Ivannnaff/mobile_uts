# 🍛 MADHANG — Ringkasan Project

> *"Madhang" berarti makan dalam bahasa Jawa.* MADHANG adalah prototipe aplikasi pemesanan makanan berbasis Flutter dengan tampilan oranye, dominan foto, dan terasa seperti aplikasi mobile.

---

## 1. Identitas Project

| | |
|---|---|
| **Nama aplikasi** | MADHANG |
| **Jenis** | Aplikasi pemesanan makanan (prototipe) |
| **Framework** | Flutter 3.10+ (Dart) |
| **Platform** | Android (utama), iOS dan Web (opsional) |
| **Tujuan** | Tugas kuliah: UI dasar, layout, spacing, gambar, dan navigasi |
| **Paket eksternal** | Tidak ada |
| **Backend** | Tidak ada (data contoh di dalam kode) |
| **Bahasa antarmuka** | Indonesia |
| **Format foto** | WebP (`fm=webp` untuk jaringan, `.webp` untuk aset lokal) |

## 2. Deskripsi Singkat

Pengguna membuka aplikasi, masuk, memilih selera makanan, lalu menjelajahi restoran terdekat dari Beranda. Setelah memilih restoran, pengguna menambahkan menu ke keranjang, melihat ringkasan pembayaran, dan memesan. Aplikasi menutup alur dengan layar konfirmasi berisi nomor pesanan dan estimasi tiba.

## 3. Fitur Utama

| Fitur | Keterangan |
|---|---|
| Splash dan login | Layar pembuka dan formulir login (tampilan) |
| Pemilihan selera | Grid kategori yang dapat dipilih (border oranye + centang) |
| Bottom navigation | Beranda, Favorit, Pesanan, Profil |
| Beranda | Alamat, pencarian (tampilan), banner promo, kategori, daftar restoran |
| Detail restoran | Foto header, info, dan daftar menu dengan tombol tambah/kurang |
| Keranjang sticky | Tombol bawah dengan jumlah item dan total |
| Checkout | Alamat, item, subtotal, ongkir, total, metode bayar (COD) |
| Konfirmasi | Nomor pesanan, estimasi tiba, dan total |
| Profil | Identitas contoh, 4 statistik, dan menu |

## 4. Layar dan Alur

**7 route** (+ 4 tab di dalam `MainShell` = **10 layar**):

```
SplashPage → LoginPage → PreferencePage → MainShell [Beranda | Favorit | Pesanan | Profil]
                                                │
                       RestaurantPage ← kartu restoran
                              │
                        CheckoutPage → SuccessPage → kembali ke Beranda
```

| # | Route | Fungsi | Navigasi utama |
|---|---|---|---|
| 1 | `SplashPage` | Pembuka | `push` ke Login |
| 2 | `LoginPage` | Masuk (tampilan) | `push` ke Preferensi |
| 3 | `PreferencePage` | Pilih selera | `pushAndRemoveUntil` ke MainShell |
| 4 | `MainShell` | 4 tab | `push` ke Restoran |
| 5 | `RestaurantPage` | Menu dan keranjang | `push` ke Checkout, `pop` kembali |
| 6 | `CheckoutPage` | Ringkasan pembayaran | `push` ke Sukses, `pop` kembali |
| 7 | `SuccessPage` | Konfirmasi | `popUntil` ke Beranda |

## 5. Kesesuaian dengan Syarat Tugas

| Syarat | Terpenuhi lewat |
|---|---|
| Text, TextStyle, Icon, Color, Container | Semua halaman; palet warna konstan |
| Row, Column, kombinasi | Kartu restoran, baris menu, statistik, bottom nav |
| Margin, padding, SizedBox | Margin kartu, padding halaman, jarak `SizedBox` |
| Image dengan ukuran dan BoxFit | Widget `Photo` (`Image.network`, `BoxFit.cover`) dan `DecorationImage` |
| Minimal 5 halaman, `push()` / `pop()` | 7 route, ditambah `pushAndRemoveUntil` dan `popUntil` |

## 6. Data Contoh

| Data | Jumlah |
|---|---|
| Restoran | 4 (Warung Madhang Bu Tini, Sate Pak Kumis, Bakso Mas Joko, Nasi Goreng Kang Ujang) |
| Menu | 12 (3 per restoran) |
| Kategori selera | 8 (Nasi, Ayam, Sate, Bakso, Mie, Salad, Burger, Dessert) |
| Kategori di Beranda | 6 |

**Aturan harga:** `total = subtotal + ongkos kirim` (tanpa pajak).

## 7. Desain Singkat

| Token | Nilai |
|---|---|
| Warna utama | `#FF5A2D` (oranye) |
| Teks gelap | `#1E1E22` |
| Teks sekunder | `#8A8A93` |
| Latar kolom | `#F4F4F6` |
| Bentuk | Tombol pill (radius 27), kartu radius 22 |
| Pola mobile | Bottom nav, header gambar, tombol sticky, ripple, scroll memantul, lebar maks 430 dp |

## 8. Cara Menjalankan

```bash
flutter create madhang
cd madhang
# ganti lib/main.dart dengan kode di madhang_app.md (bagian Source Code)
# ganti test/widget_test.dart dengan: void main() {}
flutter run              # atau: flutter run -d chrome
```

Panduan lengkap instalasi dan pengujian: `madhang_setup_guide.md`.
Untuk build rilis Android, tambahkan izin `INTERNET` pada `AndroidManifest.xml`.

## 9. Struktur Dokumen

| File | Isi |
|---|---|
| `madhang_app.md` | Kode sumber lengkap, pemetaan referensi, tabel uji alur |
| `madhang_setup_guide.md` | Panduan instalasi Flutter, membuat project, menjalankan, foto WebP lokal, dan uji alur |
| `madhang_prd.md` | Kebutuhan produk (tujuan, user story, kebutuhan, metrik) |
| `madhang_design.md` | Sistem visual, komponen, wireframe, navigasi |
| `madhang_architecture.md` | Struktur kode, alur data, keputusan arsitektur |
| `madhang_performance.md` | Target, temuan, optimasi, cara mengukur |
| `madhang_privacy.md` | Inventaris data, izin, rencana privasi, template kebijakan |
| `madhang_project_summary.md` | Dokumen ini |

## 10. Status dan Keterbatasan

| Status | Keterangan |
|---|---|
| ✅ Selesai | Seluruh alur dari splash sampai konfirmasi pesanan |
| ⚠️ Tampilan saja | Login, pencarian, "Lihat semua", favorit (ikon hati), dan metode pembayaran |
| ⚠️ Data contoh | Nama, alamat, riwayat pesanan, dan statistik profil |
| ⚠️ Belum diuji | Kode belum dijalankan di Flutter; jalankan tabel uji 12 langkah |
| ⚠️ Foto | Semua foto diminta sebagai WebP; tautan Unsplash belum diverifikasi, ikon pengganti tampil bila gagal |
| ❌ Belum ada | Backend, penyimpanan lokal, pengujian otomatis, mode gelap |

## 11. Rencana Pengembangan

1. Tambahkan `loadingBuilder` dan cache gambar (lihat `madhang_performance.md`).
2. Perbesar target sentuh dan tambahkan label aksesibilitas.
3. Keranjang lintas halaman dengan state management.
4. Pencarian dan filter yang berfungsi.
5. Autentikasi dan backend (lihat `madhang_privacy.md` dan `madhang_architecture.md`).
6. Pecah kode menjadi folder `models/`, `widgets/`, dan `pages/`.
7. Tambahkan unit dan widget test.

## 12. Cara Presentasi Singkat (±3 Menit)

1. **Masalah:** memesan makanan sering ribet dan harga baru jelas di akhir.
2. **Solusi:** MADHANG, alur pendek dengan foto besar dan total yang jelas.
3. **Demo:** Splash → Login → Preferensi → Beranda → Restoran → tambah menu → Checkout → Sukses.
4. **Teknis:** tunjukkan `Row`/`Column`, `Container`, `Image.network` + `BoxFit.cover`, `Navigator.push`/`pop`.
5. **Catatan:** ini prototipe; data contoh dan tanpa backend.
6. **Rencana:** state management, backend, dan peningkatan performa serta privasi.
