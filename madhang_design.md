# Dokumen Desain — MADHANG

Berisi prinsip desain, sistem visual, komponen, wireframe, dan pola interaksi. Sesuai dengan kode di `madhang_app.md` dan terinspirasi dari referensi aplikasi pemesanan makanan oranye (Purxx).

---

## 1. Prinsip Desain

1. **Mobile-first, bukan web:** satu layar satu tujuan; navigasi bawah; tombol besar.
2. **Berbasis foto:** foto makanan yang besar dan hangat menjadi pusat perhatian.
3. **Satu warna aksen:** oranye untuk semua aksi utama, sehingga pengguna selalu tahu apa yang bisa ditekan.
4. **Ramah jempol:** aksi penting berada di bagian bawah layar (bottom bar, tombol sticky).
5. **Sederhana:** komponen dasar Flutter yang diajarkan di kuliah.

## 2. Mengapa Terlihat Seperti Aplikasi

| Pola | Penerapan |
|---|---|
| Navigasi permanen | Bottom navigation 4 tab dengan sudut atas membulat |
| Halaman penuh | Splash, login, dan preferensi mengisi seluruh layar |
| Header gambar | Foto restoran dengan tombol back dan favorit melayang |
| Aksi menempel | Tombol **Lihat Keranjang** dan **Pesan Sekarang** di bawah |
| Umpan balik sentuhan | `InkWell` (ripple) pada tombol utama; centang dan border pada pilihan |
| Perilaku sistem | Scroll memantul, portrait, status bar transparan, `SafeArea` |
| Lebar terkontrol | Maksimal 430 dp walau dijalankan di Chrome atau tablet |

## 3. Sistem Visual

### 3.1 Warna

| Token | Hex | Kegunaan |
|---|---|---|
| `kOrange` | `#FF5A2D` | Tombol utama, tab aktif, harga, aksen |
| `kInk` | `#1E1E22` | Latar splash, judul |
| `kGrey` | `#8A8A93` | Teks sekunder, ikon tidak aktif |
| `kField` | `#F4F4F6` | Kolom input, pencarian, kartu statistik |
| Putih | `#FFFFFF` | Latar halaman dan kartu |
| Peach | `#FFE3DA` / `#FFEEE8` | Placeholder gambar, latar ikon kategori |
| Hijau status | `#00A650` | Label "Selesai" |

### 3.2 Tipografi (font bawaan Flutter)

| Peran | Ukuran | Berat |
|---|---|---|
| Logo splash | 44 (letter-spacing 5) | w900 |
| Judul halaman | 24–30 | Bold |
| Judul bagian | 18–20 | Bold |
| Nama menu / restoran | 15–17 | Bold |
| Isi | 13–15 | Regular |
| Keterangan | 11–12 | Regular / Bold |

### 3.3 Spasi, bentuk, dan bayangan

| Elemen | Nilai |
|---|---|
| Skala spasi | 4 · 8 · 12 · 16 · 20 · 24 |
| Padding halaman | 20–24 |
| Radius | Tombol 27 (pill) · Kartu 22 · Kolom input 16 · Gambar 14–24 |
| Bayangan kartu | Hitam 8% · blur 14 · offset (0, 6) |
| Bayangan tombol oranye | `#FF5A2D` 33% · blur 14 · offset (0, 6) |

## 4. Komponen

| Komponen | Deskripsi | Dipakai di |
|---|---|---|
| `Photo` | `Image.network` (foto WebP) dengan ukuran, `BoxFit.cover`, sudut membulat, dan ikon pengganti | Semua |
| `OrangeButton` | Tombol pill oranye tinggi 54 dengan ripple | Splash, Login, Restoran, Checkout |
| `RoundIcon` | Tombol bulat 38 dp (back, favorit) | Preferensi, Restoran, Checkout |
| `AppField` | `TextField` isian abu-abu dengan ikon | Login |
| `CategoryChip` | Ikon dalam kotak peach + label | Beranda |
| `RestaurantCard` | Foto besar, nama, rating, waktu, jarak, ongkir | Beranda, Favorit |
| `SummaryRow` | Label kiri, nilai kanan (opsi tebal oranye) | Checkout, Sukses |
| `TabPage` | Judul besar + daftar konten | Favorit, Pesanan, Profil |
| Bottom bar | 4 `navItem` (ikon + label) | `MainShell` |

## 5. Wireframe

### 5.1 Splash
```
┌────────────────────────┐
│ [foto]       [foto]    │
│                        │
│        MADHANG         │
│  Pesan makanan favorit │
│                        │
│ [foto]       [foto]    │
│ [        Mulai       ] │
└────────────────────────┘
```

### 5.2 Login
```
┌────────────────────────┐
│ ▓▓▓▓ foto gelap ▓▓▓▓▓▓ │
│ MADHANG                │  ← sudut bawah membulat
├────────────────────────┤
│ Selamat datang!        │
│ [✉ Email            ]  │
│ [🔒 Password        ]  │
│            Lupa pass?  │
│ [        Masuk       ] │
│ ─────── atau ───────   │
│    (G)   (f)   ( )     │
└────────────────────────┘
```

### 5.3 Preferensi
```
┌────────────────────────┐
│ (←)                    │
│ Kamu suka              │
│ makan apa?             │
│ 2 dipilih              │
│ [ Nasi ✔ ][ Ayam   ]   │
│ [ Sate   ][ Bakso✔ ]   │
│ ...                    │
│ [ Lewati ]        (→)  │
└────────────────────────┘
```

### 5.4 Beranda
```
┌────────────────────────┐
│ Dikirim ke         (🔔)│
│ 📍 Rumah • Jl. Melati  │
│ [🔍 Cari makanan...  ] │
│ ┌ PROMO HARI INI ────┐ │
│ │ Diskon 50%    (foto)│ │
│ └─────────────────────┘ │
│ (Nasi)(Burger)(Mie)... │
│ Terdekat dari kamu     │
│ ┌ [   foto besar   ] ┐ │
│ │ Nama         ★ 4.8 │ │
│ │ ⏱ 20 min 📍1.2km 🛵│ │
│ └─────────────────────┘ │
├────────────────────────┤
│ 🏠    ❤    🧾    👤    │
└────────────────────────┘
```

### 5.5 Detail Restoran
```
┌────────────────────────┐
│ ▓▓ foto header ▓▓▓▓▓▓▓ │
│ (←)               (♡)  │
├────────────────────────┤
│ Warung Madhang Bu Tini │
│ ★ 4.8  ⏱ 20-30  📍 1.2 │
│ Menu                   │
│ [img] Nama       Rp .. │
│       deskripsi   (+)  │
│ [img] Nama       Rp .. │
│       deskripsi (−)1(+)│
├────────────────────────┤
│ [Lihat Keranjang • 2 • │  ← sticky
│                Rp 51k] │
└────────────────────────┘
```

### 5.6 Checkout
```
┌────────────────────────┐
│ (←) Pesanan Saya       │
│ ┌ 📍 Rumah • Jl. ... ┐ │
│ Nama Restoran          │
│ [img] Menu x2   Rp ..  │
│ ────────────────────── │
│ Subtotal        Rp ..  │
│ Ongkos kirim    Rp ..  │
│ Total           Rp ..  │  ← oranye, tebal
│ ┌ 💰 Bayar di tempat ✔┐│
│ [Pesan Sekarang • Rp ] │
└────────────────────────┘
```

### 5.7 Sukses
```
┌────────────────────────┐ (latar oranye penuh)
│          ( ✔ )         │
│   Pesanan diterima!    │
│ ┌ No. pesanan  MDH-.. ┐│
│ │ Estimasi    25-30 m ││
│ │ Total       Rp ..   ││
│ └─────────────────────┘ │
│ [ Kembali ke Beranda ] │  ← tombol putih
└────────────────────────┘
```

### 5.8 Profil
```
┌────────────────────────┐
│ Profil                 │
│ (A) Andi Pratama       │
│ ┌ 24 ──┐ ┌ 8 ───┐      │
│ │Pesan │ │Favorit│     │
│ ┌ 3 ───┐ ┌ 1.250 ┐     │
│ │Voucher││ Poin  │     │
│ 📍 Alamat tersimpan  › │
│ 💳 Metode pembayaran › │
│ ❓ Bantuan           › │
│ ⎋  Keluar            › │
└────────────────────────┘
```

## 6. Peta Navigasi

| Dari | Pemicu | Ke | Metode |
|---|---|---|---|
| Splash | Mulai | Login | `push` |
| Login | Masuk | Preferensi | `push` |
| Preferensi | Lewati / panah | Beranda (MainShell) | `pushAndRemoveUntil` |
| Preferensi | Tombol back | Login | `pop` |
| Beranda / Favorit | Kartu restoran | Detail Restoran | `push` |
| Detail Restoran | Lihat Keranjang | Checkout | `push` |
| Checkout | Pesan Sekarang | Sukses | `push` |
| Sukses | Kembali ke Beranda | Beranda | `popUntil(first)` |
| Detail / Checkout | Tombol back | Halaman sebelumnya | `pop` |
| Profil | Keluar | Splash | `pushAndRemoveUntil` |

## 7. Keadaan dan Interaksi

| Keadaan | Perilaku |
|---|---|
| Gambar gagal dimuat | Kotak peach dengan ikon restoran |
| Keranjang kosong | Tombol **Lihat Keranjang** tidak ditampilkan |
| Jumlah menu menjadi 0 | Kontrol berubah kembali menjadi tombol **+** |
| Kategori dipilih | Border oranye 3 dp dan ikon centang |
| Deskripsi panjang | Dipotong 2 baris dengan elipsis |
| Tab aktif | Ikon dan label oranye; tab lain abu-abu |

## 8. Aksesibilitas

| Aspek | Kondisi sekarang | Perbaikan yang disarankan |
|---|---|---|
| Kontras teks | Putih pada foto digelapkan; gelap pada putih | Sudah baik |
| Ukuran target sentuh | Tombol utama 54 dp; tombol bulat 32–38 dp | Naikkan tombol +/− dan back ke minimal 44–48 dp |
| Label pembaca layar | Belum ada | Tambahkan `Semantics` atau `tooltip` pada ikon tombol |
| Teks kecil | 11–12 sp hanya untuk keterangan | Tetap, jangan dipakai untuk info penting |
| Ukuran font sistem | Tidak diuji | Uji dengan skala font 1,3× |

## 9. Gaya Bahasa (Konten)

- Bahasa Indonesia santai dan singkat: "Mulai", "Masuk", "Lewati", "Pesan Sekarang".
- Nama merek dengan huruf kapital semua: **MADHANG**.
- Harga: `Rp 25.000`; waktu: `20-30 min`; jarak: `1.2 km`.

## 10. Gambar

| Aturan | Detail |
|---|---|
| Format | **WebP** untuk semua foto (jaringan: `fm=webp`; lokal: `.webp`) |
| Lebar sumber | 700 px, kualitas 70–75 |
| Fit | `BoxFit.cover` di semua tempat agar foto tidak gepeng |
| Ukuran tampil | Kartu restoran: lebar penuh × 150 · Menu: 84×84 · Checkout: 56×56 · Header restoran: lebar penuh × 250 · Banner: 110×110 (bulat) |
| Overlay | Gelap 38–54% pada foto dengan teks putih |
| Fallback | Kotak peach dengan ikon restoran saat foto gagal dimuat |
