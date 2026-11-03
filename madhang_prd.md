# PRD — MADHANG (Aplikasi Pemesanan Makanan)

| | |
|---|---|
| **Produk** | MADHANG, aplikasi mobile pemesanan makanan ("madhang" = makan dalam bahasa Jawa) |
| **Versi** | 1.0 (proyek kuliah / prototipe) |
| **Platform** | Flutter (Android utama; iOS dan Web opsional) |
| **Status** | Draft |
| **Dokumen terkait** | `madhang_app.md` (kode), `madhang_design.md`, `madhang_architecture.md`, `madhang_performance.md`, `madhang_privacy.md`, `madhang_project_summary.md` |

---

## 1. Ringkasan

MADHANG membantu pengguna menemukan restoran terdekat, memilih menu, dan memesan makanan dengan alur singkat. Tampilannya mengikuti pola aplikasi mobile: splash, login, pemilihan selera, beranda dengan bottom navigation, detail restoran, checkout, dan konfirmasi pesanan.

> **Catatan:** v1.0 adalah **prototipe tanpa backend**. Data restoran tersimpan di dalam kode, login tidak memverifikasi akun, dan pesanan tidak dikirim ke server.

## 2. Latar Belakang dan Masalah

| Masalah pengguna | Solusi MADHANG |
|---|---|
| Sulit memilih makanan karena menu tanpa foto | Tampilan berbasis foto di setiap restoran dan menu |
| Harga akhir baru diketahui di akhir | Ringkasan subtotal, ongkos kirim, dan total sebelum memesan |
| Terlalu banyak langkah untuk memesan | Alur pendek: pilih restoran, tambah menu, keranjang, pesan |
| Aplikasi terasa seperti situs web | Navigasi bawah, halaman penuh, tombol besar, dan umpan balik sentuhan |

## 3. Tujuan dan Non-Tujuan

### Tujuan
- **G1.** Pengguna dapat memesan makanan dalam **7 ketukan** atau kurang dari peluncuran aplikasi.
- **G2.** Antarmuka terasa seperti aplikasi mobile (bukan web) pada layar 360–430 dp.
- **G3.** Harga ditampilkan jelas dalam format Rupiah (`Rp 25.000`).
- **G4.** Memenuhi materi kuliah: UI dasar, layout, spacing, gambar, dan navigasi lebih dari 5 halaman.

### Non-Tujuan (v1.0)
- Autentikasi, akun, dan penyimpanan data pengguna
- Pembayaran nyata, pelacakan driver, dan peta
- Backend, database, dan notifikasi push
- Keranjang gabungan lintas restoran

## 4. Persona

| Persona | Deskripsi | Kebutuhan |
|---|---|---|
| **Andi (23, mahasiswa)** | Sering memesan makan siang | Cepat, harga jelas, ongkir murah |
| **Sari (31, pekerja kantor)** | Memesan untuk rekan kerja | Bisa menambah jumlah porsi, lihat total |
| **Penguji** | Menilai proyek sesuai tugas | Navigasi berfungsi, komponen Flutter terlihat jelas |

## 5. User Story

| ID | Sebagai… | Saya ingin… | Agar… | Prioritas |
|---|---|---|---|---|
| US-1 | pengguna baru | melihat layar pembuka yang menarik | mengenal merek MADHANG | Should |
| US-2 | pengguna | masuk lewat layar login | merasa memakai aplikasi sungguhan | Should |
| US-3 | pengguna | memilih jenis makanan favorit | rekomendasi terasa personal | Could |
| US-4 | pengguna | melihat restoran terdekat dengan rating, jarak, dan ongkir | memilih dengan cepat | Must |
| US-5 | pengguna | berpindah antartab (Beranda, Favorit, Pesanan, Profil) | mengakses fitur utama dalam satu ketukan | Must |
| US-6 | pengguna | menambah dan mengurangi jumlah menu | memesan sesuai kebutuhan | Must |
| US-7 | pengguna | melihat ringkasan pembayaran | tidak ada biaya mengejutkan | Must |
| US-8 | pengguna | mendapat konfirmasi dan nomor pesanan | yakin pesanan diterima | Must |
| US-9 | pengguna | kembali ke halaman sebelumnya dari mana pun | tidak merasa terjebak | Must |
| US-10 | pengguna | melihat statistik profil | merasa dihargai (pesanan, voucher, poin) | Could |

## 6. Kebutuhan Fungsional

| ID | Kebutuhan | Halaman | Prioritas |
|---|---|---|---|
| FR-1 | Splash menampilkan logo, tagline, foto makanan, dan tombol **Mulai** | `SplashPage` | Should |
| FR-2 | Login menampilkan kolom email dan password, tombol **Masuk**, dan ikon login sosial | `LoginPage` | Should |
| FR-3 | Pengguna dapat memilih satu atau lebih kategori makanan; pilihan ditandai border oranye dan ikon centang; ada tombol **Lewati** | `PreferencePage` | Could |
| FR-4 | Setelah masuk, riwayat navigasi dibersihkan agar tombol back tidak kembali ke login | `PreferencePage` | Must |
| FR-5 | Bottom navigation dengan 4 tab: Beranda, Favorit, Pesanan, Profil | `MainShell` | Must |
| FR-6 | Beranda menampilkan alamat pengiriman, kolom pencarian (tampilan), banner promo, kategori, dan daftar restoran | `HomeTab` | Must |
| FR-7 | Kartu restoran menampilkan foto, nama, jenis masakan, rating, waktu, jarak, dan ongkir | `RestaurantCard` | Must |
| FR-8 | Favorit menampilkan restoran dengan rating 4,7 ke atas | `FavoritesTab` | Could |
| FR-9 | Pesanan menampilkan riwayat contoh (data statis) | `OrdersTab` | Could |
| FR-10 | Profil menampilkan identitas contoh, 4 kartu statistik, dan menu; **Keluar** kembali ke splash | `ProfileTab` | Could |
| FR-11 | Detail restoran menampilkan foto header, tombol kembali, info, dan daftar menu | `RestaurantPage` | Must |
| FR-12 | Tombol **+** menambah menu; kontrol **− jumlah +** muncul setelahnya; jumlah tidak bisa negatif | `RestaurantPage` | Must |
| FR-13 | Tombol bawah **Lihat Keranjang** muncul hanya jika ada item, menampilkan jumlah item dan total | `RestaurantPage` | Must |
| FR-14 | Checkout menampilkan alamat, daftar item, subtotal, ongkir, total, dan metode bayar (COD) | `CheckoutPage` | Must |
| FR-15 | **Pesan Sekarang** membuka halaman sukses dengan nomor pesanan, estimasi tiba, dan total | `SuccessPage` | Must |
| FR-16 | **Kembali ke Beranda** menutup semua halaman checkout dan kembali ke Beranda | `SuccessPage` | Must |
| FR-17 | Gambar yang gagal dimuat diganti ikon pengganti | Semua | Must |

## 7. Kebutuhan Non-Fungsional

| ID | Kebutuhan |
|---|---|
| NFR-1 | Berjalan di Flutter 3.10+ tanpa paket pihak ketiga |
| NFR-2 | Layout tanpa overflow pada lebar 360–430 dp; lebar dibatasi 430 dp di layar besar |
| NFR-3 | Layar terkunci mode portrait; status bar transparan |
| NFR-4 | Target performa dijelaskan di `madhang_performance.md` |
| NFR-5 | Kebijakan data dan privasi dijelaskan di `madhang_privacy.md` |
| NFR-6 | Kode terbagi menjadi widget kecil yang dapat dipakai ulang |
| NFR-7 | Semua foto memakai format **WebP** (jaringan: `fm=webp`; aset lokal: `.webp`) untuk unduhan yang lebih kecil |

## 8. Alur Utama

```
Splash → Login → Preferensi → [Beranda | Favorit | Pesanan | Profil]
                                   │
                      Kartu restoran → Detail Restoran → Checkout → Sukses → Beranda
```

## 9. Ruang Lingkup

| MVP v1.0 (ada) | Berikutnya (belum ada) |
|---|---|
| 7 route, 10 layar (termasuk 4 tab) | Autentikasi sungguhan |
| 4 restoran, 12 menu, 8 kategori selera | Pencarian dan filter yang berfungsi |
| Keranjang per restoran (di memori) | Keranjang gabungan dan catatan pesanan |
| Pembayaran COD (tampilan) | Dompet digital dan kartu |
| Data statis di kode | API dan database |

## 10. Model Data

| Model | Kolom |
|---|---|
| `Dish` | name, desc, price (int, Rupiah), image |
| `Restaurant` | name, cuisine, image, distance, time, rating, fee (int), menu (List<Dish>) |
| `CartLine` | dish, qty |

## 11. Aturan Bisnis

1. `subtotal = Σ (harga menu × jumlah)`
2. `total = subtotal + ongkos kirim restoran`
3. Tidak ada pajak atau biaya layanan pada v1.0.
4. Jumlah menu minimal 0; item berjumlah 0 tidak masuk keranjang.
5. Keranjang hanya berlaku pada satu restoran dan hilang saat halaman restoran ditutup.
6. Nomor pesanan dibuat acak dengan awalan `MDH-`.

## 12. Metrik Keberhasilan

| Metrik | Target |
|---|---|
| Ketukan dari peluncuran sampai pesanan terkonfirmasi | 7 atau kurang (Mulai, Masuk, Lewati, kartu, +, Keranjang, Pesan) |
| Komponen materi kuliah tercakup | 5 dari 5 |
| Halaman yang dapat dijangkau lewat navigasi | 7 dari 7 route |
| Error overflow pada lebar 360 dp | 0 |
| `flutter analyze` | 0 error |

## 13. Asumsi dan Batasan

- Semua data adalah contoh; tidak ada transaksi nyata.
- Foto dimuat dari internet (Unsplash) dalam format WebP; tanpa internet, ikon pengganti tampil.
- Aplikasi hanya diuji untuk orientasi portrait.

## 14. Risiko

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Tautan foto rusak atau tidak ada internet | Foto kosong | Ikon pengganti (FR-17); opsi `Image.asset` |
| Flutter versi lama | Error kompilasi | Wajibkan Flutter 3.10+ |
| Pengguna mengira login/pembayaran sungguhan | Salah paham | Beri label "prototipe" saat presentasi |
| Perluasan fitur berlebihan | Tenggat terlewat | Pertahankan non-tujuan v1.0 |

## 15. Milestone

| Milestone | Hasil |
|---|---|
| M1 Persiapan | Flutter terpasang, project dibuat |
| M2 Fondasi | Tema, model data, widget bersama |
| M3 Halaman | Semua 7 route selesai |
| M4 Alur | Pemesanan berjalan dari awal sampai akhir |
| M5 Poles dan uji | Tabel uji lulus, `flutter analyze` bersih |
| M6 Pengumpulan | Dokumen digabung dan dicek ulang |

## 16. Pertanyaan Terbuka

1. Apakah foto memakai jaringan atau aset lokal (`Image.asset`)?
2. Apakah versi berikutnya memakai backend sungguhan (mis. Firebase atau REST API)?
3. Apakah aplikasi perlu mendukung bahasa Inggris selain Indonesia?

## 17. Kesesuaian dengan Syarat Tugas

| Syarat | Pemenuhan |
|---|---|
| Text, TextStyle, Icon, Color, Container | Semua halaman; palet `kOrange`, `kInk`, `kGrey`, `kField` |
| Row, Column, kombinasi | `RestaurantCard`, baris menu, kartu statistik, bottom nav |
| Margin, padding, SizedBox | Margin kartu, padding halaman, jarak `SizedBox` |
| Image dengan ukuran dan BoxFit | `Photo` (`Image.network`, `width`, `height`, `BoxFit.cover`) dan `DecorationImage` |
| Minimal 5 halaman, `push()` dan `pop()` | 7 route; `push`, `pop`, `pushAndRemoveUntil`, `popUntil` |
