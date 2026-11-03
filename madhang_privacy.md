# Privasi dan Data — MADHANG

Dokumen ini menjelaskan data apa yang disentuh aplikasi, ke mana data itu pergi, dan apa yang harus disiapkan jika aplikasi dikembangkan menjadi produk nyata.

> **Penafian:** dokumen ini bukan nasihat hukum. Untuk produk yang dirilis, konsultasikan dengan ahli hukum dan pelajari regulasi yang berlaku, misalnya UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP) di Indonesia.

---

## 1. Ringkasan Singkat (Versi 1.0 Prototipe)

| Pertanyaan | Jawaban |
|---|---|
| Apakah aplikasi mengumpulkan data pribadi? | **Tidak.** Tidak ada data yang dikirim atau disimpan |
| Apakah ada akun dan login sungguhan? | **Tidak.** Kolom email dan password hanya tampilan; isinya tidak dibaca |
| Apakah ada penyimpanan di perangkat? | **Tidak.** Semua state hilang saat aplikasi ditutup |
| Apakah ada server milik MADHANG? | **Tidak** |
| Apakah ada analitik, iklan, atau pelacak? | **Tidak** |
| Apakah ada izin khusus (lokasi, kamera, kontak)? | **Tidak.** Hanya akses internet |
| Apakah ada permintaan jaringan? | **Ya**, hanya untuk memuat foto dari `images.unsplash.com` |

## 2. Inventaris Data

| Data | Muncul di | Asal | Disimpan? | Dikirim keluar? |
|---|---|---|---|---|
| Email dan password | `LoginPage` | Diketik pengguna | Tidak | Tidak |
| Nama "Andi Pratama", email "andi@email.com" | `ProfileTab` | Teks contoh di kode | Tidak (hardcode) | Tidak |
| Alamat "Rumah • Jl. Melati No. 5" | `HomeTab`, `CheckoutPage` | Teks contoh di kode | Tidak (hardcode) | Tidak |
| Pilihan kategori makanan | `PreferencePage` | Dipilih pengguna | Hanya di memori (hilang saat halaman ditutup) | Tidak |
| Isi keranjang | `RestaurantPage` | Dipilih pengguna | Hanya di memori | Tidak |
| Nomor pesanan (`MDH-xxxxx`) | `SuccessPage` | Dibuat dari jam perangkat | Tidak | Tidak |
| Statistik profil (24 pesanan, 3 voucher, dll.) | `ProfileTab`, `OrdersTab` | Angka contoh | Tidak (hardcode) | Tidak |

## 3. Permintaan Jaringan

| Tujuan | Isi | Data yang dapat terlihat oleh pihak ketiga |
|---|---|---|
| `images.unsplash.com` | Permintaan untuk mengunduh foto | Alamat IP perangkat, jenis perangkat dan versi aplikasi (user-agent), waktu dan URL foto yang diminta |

Tidak ada permintaan lain. Tidak ada cookie atau identitas pengguna yang dikirim oleh kode aplikasi.

## 4. Izin Aplikasi

| Izin | Status | Keterangan |
|---|---|---|
| `INTERNET` (Android) | Diperlukan | Untuk memuat foto. Pada build debug otomatis aktif; pada build release harus ditambahkan manual |
| Lokasi, kamera, mikrofon, kontak, penyimpanan, notifikasi | **Tidak diminta** | – |

## 5. Keamanan pada v1.0

| Aspek | Kondisi |
|---|---|
| Rahasia (API key, token) di kode | Tidak ada |
| Transport | URL foto memakai HTTPS |
| Penyimpanan data sensitif | Tidak ada |
| Kolom password | Memakai `obscureText: true` (tersembunyi di layar), tetapi **tidak ada verifikasi** |
| Permukaan serangan | Sangat kecil, karena tidak ada backend dan tidak ada data nyata |

> **Peringatan untuk presentasi:** jangan memasukkan email atau password asli ke kolom login prototipe. Kolom itu belum terhubung ke apa pun, tetapi kebiasaan ini tetap baik.

## 5a. Catatan tentang Layanan Foto

Foto berasal dari Unsplash. Periksa lisensi dan ketentuan layanan Unsplash sebelum menggunakan foto di produk yang dirilis. Untuk rilis nyata, gunakan foto milik sendiri atau berlisensi yang jelas, dan simpan sebagai aset lokal atau di server sendiri.

---

## 6. Jika Aplikasi Dikembangkan Menjadi Produk Nyata

### 6.1 Data yang kemungkinan akan dikumpulkan

| Kategori | Contoh | Tujuan | Dasar/Catatan |
|---|---|---|---|
| Identitas akun | Nama, email, nomor telepon | Membuat akun, login, kontak pesanan | Perlu persetujuan dan kebijakan |
| Alamat dan lokasi | Alamat antar, koordinat | Pengiriman dan estimasi jarak | Termasuk data sensitif secara praktik; minta izin lokasi hanya saat dipakai |
| Riwayat pesanan | Restoran, menu, total, waktu | Riwayat, dukungan pelanggan, pembukuan | Tentukan masa simpan |
| Data pembayaran | Metode, status | Menyelesaikan transaksi | **Jangan simpan nomor kartu sendiri**; gunakan penyedia pembayaran berlisensi |
| Preferensi | Kategori makanan favorit | Personalisasi | Opsional dan dapat dimatikan |
| Data teknis | Jenis perangkat, versi aplikasi, log kerusakan | Perbaikan bug | Minimalkan dan anonimkan |
| Push token | Token notifikasi | Status pesanan | Izin notifikasi terpisah |

### 6.2 Prinsip yang disarankan

1. **Minimalisasi data:** kumpulkan hanya yang diperlukan.
2. **Pembatasan tujuan:** pakai data hanya untuk tujuan yang dijelaskan.
3. **Transparansi:** kebijakan privasi mudah dibaca, dalam bahasa Indonesia.
4. **Persetujuan yang jelas:** untuk lokasi, notifikasi, dan pemasaran, dengan opsi menolak.
5. **Kontrol pengguna:** dapat melihat, mengubah, mengekspor, dan menghapus data dan akun.
6. **Keamanan:** HTTPS, token disimpan di penyimpanan aman, kata sandi di-hash di server, akses berbasis peran.
7. **Masa simpan terbatas:** hapus atau anonimkan data yang tidak diperlukan lagi.
8. **Pihak ketiga:** daftarkan setiap layanan (pembayaran, peta, analitik) beserta datanya.

### 6.3 Hak pengguna yang perlu didukung

| Hak | Wujud di aplikasi |
|---|---|
| Akses dan salinan data | Menu "Unduh data saya" |
| Perbaikan data | Edit profil dan alamat |
| Penghapusan | Menu "Hapus akun" |
| Penarikan persetujuan | Pengaturan izin lokasi, notifikasi, dan pemasaran |
| Keberatan terhadap pemasaran | Opsi berhenti menerima promo |

### 6.4 Rekomendasi teknis

| Topik | Saran |
|---|---|
| Token login | `flutter_secure_storage` (Keychain/Keystore) |
| Komunikasi | HTTPS saja; pertimbangkan certificate pinning untuk API sensitif |
| Log | Jangan mencatat email, alamat, atau token di log |
| Izin | Minta pada saat dibutuhkan, dengan penjelasan singkat |
| Analitik | Opt-in dan anonim; hindari data pribadi |
| Anak di bawah umur | Tentukan batas usia dan kebijakan persetujuan orang tua |
| Pembayaran | Gunakan SDK penyedia pembayaran; jangan menyimpan data kartu |

## 7. Daftar Periksa Privasi

### Prototipe (sekarang)
- [x] Tidak ada pengumpulan atau penyimpanan data pribadi
- [x] Tidak ada analitik atau iklan
- [x] Hanya izin internet
- [x] Tidak ada rahasia di kode
- [ ] Beri label "prototipe — data contoh" saat demo atau presentasi
- [ ] Periksa lisensi foto Unsplash sebelum dipublikasikan

### Sebelum rilis nyata
- [ ] Kebijakan privasi dan syarat layanan dibuat
- [ ] Persetujuan dan izin diminta dengan benar
- [ ] Backend aman dan terenkripsi
- [ ] Mekanisme akses, ubah, dan hapus data tersedia
- [ ] Penyedia pembayaran berlisensi dipakai
- [ ] Daftar pihak ketiga dan dampaknya ditinjau
- [ ] Konsultasi hukum dilakukan

---

## 8. Template Kebijakan Privasi (Untuk Produk Nyata)

> Ini hanyalah kerangka awal. Sesuaikan dengan kenyataan produk dan tinjau oleh ahli hukum.

**Kebijakan Privasi MADHANG**
*Terakhir diperbarui: [tanggal]*

**1. Data yang kami kumpulkan.** Saat Anda membuat akun dan memesan, kami dapat mengumpulkan nama, email, nomor telepon, alamat pengiriman, riwayat pesanan, dan data teknis perangkat.

**2. Cara kami menggunakan data.** Untuk memproses pesanan, mengantar makanan, menghubungi Anda terkait pesanan, meningkatkan layanan, dan, bila Anda setuju, mengirim promo.

**3. Berbagi data.** Kami hanya membagikan data yang diperlukan kepada restoran mitra, kurir, dan penyedia pembayaran untuk menyelesaikan pesanan Anda. Kami tidak menjual data pribadi Anda.

**4. Penyimpanan dan keamanan.** Data disimpan dengan perlindungan teknis yang wajar dan hanya selama diperlukan.

**5. Hak Anda.** Anda dapat meminta akses, perbaikan, atau penghapusan data, dan menarik persetujuan kapan saja melalui [kontak].

**6. Perubahan kebijakan.** Kami akan memberi tahu Anda jika ada perubahan penting.

**7. Kontak.** [email atau alamat pengelola]

---

## 9. Pernyataan Singkat untuk Presentasi

> "MADHANG v1.0 adalah prototipe. Aplikasi ini tidak mengumpulkan, menyimpan, atau mengirim data pribadi. Satu-satunya permintaan jaringan adalah unduhan foto dari Unsplash. Semua nama, alamat, dan angka statistik adalah data contoh."
