# Arsitektur — MADHANG

Menjelaskan struktur kode, alur data, navigasi, dan rencana pengembangan. Kode lengkap ada di `madhang_app.md`.

---

## 1. Gambaran Umum

| Aspek | Keputusan saat ini (v1.0) |
|---|---|
| Framework | Flutter 3.10+ (Dart), Material 3 |
| Struktur kode | Satu file `lib/main.dart` dengan bagian yang diberi komentar |
| Arsitektur | Sederhana berlapis: **UI → model → data statis** |
| State | `setState` lokal (hanya 3 widget stateful) |
| Navigasi | Navigator imperatif (`push`, `pop`, `pushAndRemoveUntil`, `popUntil`) |
| Data | List statis di kode (`restaurants`, `categories`) |
| Backend | Tidak ada |
| Paket eksternal | Tidak ada |
| Penyimpanan lokal | Tidak ada |

## 2. Diagram Lapisan

```
┌──────────────────────────────────────────────┐
│ PRESENTASI (UI)                              │
│  Halaman: SplashPage, LoginPage,             │
│    PreferencePage, MainShell (+4 tab),       │
│    RestaurantPage, CheckoutPage, SuccessPage │
│  Widget bersama: Photo, OrangeButton,        │
│    RoundIcon, AppField, CategoryChip,        │
│    RestaurantCard, SummaryRow, TabPage       │
├──────────────────────────────────────────────┤
│ LOGIKA RINGAN                                │
│  setState: pilihan kategori, tab aktif,      │
│    jumlah menu                               │
│  Helper: go(), goRoot(), rp(), img()         │
│  Perhitungan: subtotal, total (getter)       │
├──────────────────────────────────────────────┤
│ MODEL                                        │
│  Dish · Restaurant · CartLine                │
├──────────────────────────────────────────────┤
│ DATA                                         │
│  restaurants (4) · categories (8)            │
│  Gambar: Image.network (Unsplash, WebP)      │
└──────────────────────────────────────────────┘
```

## 3. Struktur `main.dart`

```
main.dart
├── main()                    kunci portrait, status bar transparan, runApp
├── Tema + helper             kOrange, kInk, kGrey, kField, img(), rp(), go(), goRoot()
├── Data                      Dish, Restaurant, CartLine, categories, restaurants
├── MadhangApp                MaterialApp + builder (lebar maks 430 dp)
├── Widget bersama            Photo, OrangeButton, RoundIcon, AppField, CategoryChip,
│                             RestaurantCard, SummaryRow, TabPage
└── Halaman                   SplashPage → LoginPage → PreferencePage*
                              → MainShell* (HomeTab, FavoritesTab, OrdersTab, ProfileTab)
                              → RestaurantPage* → CheckoutPage → SuccessPage
                                                   (* = StatefulWidget)
```

## 4. Inventaris Kelas

| Kelas | Jenis | Tanggung jawab | State |
|---|---|---|---|
| `MadhangApp` | Stateless | Tema, `builder` pembatas lebar, `home` | – |
| `SplashPage` | Stateless | Layar pembuka | – |
| `LoginPage` | Stateless | Tampilan login (tanpa validasi) | – |
| `PreferencePage` | **Stateful** | Pemilihan kategori (`Set<String>`) | `picked` |
| `MainShell` | **Stateful** | Bottom navigation | `index` |
| `HomeTab`, `FavoritesTab`, `OrdersTab`, `ProfileTab` | Stateless | Isi tab | – |
| `RestaurantPage` | **Stateful** | Menu dan jumlah pesanan | `qty` (`Map<int,int>`) |
| `CheckoutPage` | Stateless | Ringkasan dan total | – |
| `SuccessPage` | Stateless | Konfirmasi | – |

## 5. Alur Data

```
restaurants (List<Restaurant>)
      │
      ├─► HomeTab / FavoritesTab ─► RestaurantCard(r) ──push──► RestaurantPage(r)
      │                                                           │ qty: Map<int,int>
      │                                                           ▼ getter lines → List<CartLine>
      │                                                      CheckoutPage(r, lines)
      │                                                           │ subtotal = Σ price×qty
      │                                                           │ total = subtotal + r.fee
      │                                                           ▼
      └──────────────────────────────────────────────────── SuccessPage(total)
```

- Data dikirim lewat **parameter konstruktor** (tanpa state global).
- Keranjang hanya hidup di `_RestaurantPageState`; saat halaman ditutup, keranjang hilang.

## 6. Navigasi

| Teknik | Dipakai untuk |
|---|---|
| `Navigator.push` (lewat `go()`) | Maju ke halaman berikutnya |
| `Navigator.pop` | Kembali (tombol back) |
| `Navigator.pushAndRemoveUntil` (lewat `goRoot()`) | Masuk ke aplikasi dan keluar (membersihkan tumpukan) |
| `Navigator.popUntil(route.isFirst)` | Kembali ke Beranda setelah pesanan |

> `popUntil(route.isFirst)` aman karena `MainShell` menjadi route pertama setelah `goRoot()`.

## 7. Keputusan Arsitektur

| # | Keputusan | Alasan | Konsekuensi |
|---|---|---|---|
| A1 | Satu file `main.dart` | Mudah disalin dan dinilai | Sulit dirawat saat membesar |
| A2 | `setState` saja | Sesuai materi kuliah | Keranjang tidak bisa dibagi antarhalaman |
| A3 | Data statis | Tanpa backend | Tidak ada data nyata |
| A4 | `Image.network` dengan format WebP (`fm=webp`) | Mudah, tanpa aset, unduhan lebih kecil | Butuh internet; tanpa cache disk |
| A5 | `DecorationImage` untuk teks di atas foto | Menghindari `Stack` | Tidak ada fallback saat gagal muat |
| A6 | `builder` membatasi lebar 430 dp | Tampilan konsisten seperti ponsel | Tablet tampil sebagai kolom ponsel |
| A7 | `pushAndRemoveUntil` setelah login | Perilaku back seperti aplikasi nyata | Tidak ada jalur "kembali ke login" selain Keluar |
| A8 | Widget `const` dan kelas kecil | Rebuild lebih murah, kode jelas | – |

## 8. Struktur Folder yang Disarankan (Refactor)

```
lib/
├── main.dart                     (runApp saja)
├── app.dart                      (MadhangApp + tema)
├── core/
│   ├── theme/colors.dart         (kOrange, kInk, ...)
│   └── utils/format.dart         (rp(), img())
├── models/
│   ├── dish.dart
│   ├── restaurant.dart
│   └── cart_line.dart
├── data/
│   └── sample_data.dart          (restaurants, categories)
├── widgets/
│   ├── photo.dart
│   ├── orange_button.dart
│   ├── restaurant_card.dart
│   └── ...
└── pages/
    ├── splash_page.dart
    ├── login_page.dart
    ├── preference_page.dart
    ├── main_shell.dart
    ├── tabs/ (home, favorites, orders, profile)
    ├── restaurant_page.dart
    ├── checkout_page.dart
    └── success_page.dart
```

## 9. Arsitektur Target (Jika Dikembangkan)

```
UI (Pages/Widgets)
   │ membaca / memanggil
   ▼
State management (Provider / Riverpod / Bloc)   ← CartController, AuthController
   │
   ▼
Repository  ← RestaurantRepository, OrderRepository, AuthRepository
   │
   ├─► Remote data source (REST API / Firebase)
   └─► Local data source (shared_preferences / secure storage / cache gambar)
```

| Kebutuhan | Pilihan yang masuk akal |
|---|---|
| Keranjang lintas halaman | State management tingkat aplikasi |
| Autentikasi | Firebase Auth atau token JWT + penyimpanan aman |
| Data restoran dan pesanan | REST API atau Firestore |
| Cache gambar | `cached_network_image` |
| Navigasi bernama dan deep link | `go_router` |
| Peta dan lokasi | `google_maps_flutter` + izin lokasi |

## 10. Strategi Pengujian

| Jenis | Cakupan | Contoh |
|---|---|---|
| Analisis statis | Seluruh kode | `flutter analyze` |
| Unit test | Fungsi murni | `rp(28000) == 'Rp 28.000'`; total = subtotal + ongkir |
| Widget test | Halaman penting | Tekan **+** → tombol keranjang muncul; tekan **−** sampai 0 → hilang |
| Uji alur manual | Semua route | Tabel 12 langkah di `madhang_app.md` |
| Golden test (opsional) | Tampilan | Splash, Beranda, Checkout |

## 11. Batasan yang Diketahui

- Tidak ada penyimpanan: semua state hilang saat aplikasi ditutup.
- Login, pencarian, favorit, dan "Lihat semua" hanya tampilan.
- `PreferencePage` memakai grid dua kolom manual dan mengasumsikan jumlah kategori genap.
- `DecorationImage` (hero, kategori, header) belum punya fallback jika foto gagal.
- Tidak ada pengujian otomatis di v1.0.
