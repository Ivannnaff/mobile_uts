# Performa — MADHANG

Menjelaskan target performa, kondisi kode saat ini, optimasi yang disarankan, dan cara mengukurnya.

> **Catatan jujur:** dokumen ini **belum berisi hasil pengukuran**. Angka pada bagian "Target" adalah sasaran, bukan hasil. Isi tabel di bagian 7 setelah kamu mengukur di perangkatmu.

---

## 1. Target Performa

| Metrik | Target | Cara ukur |
|---|---|---|
| Kelancaran animasi dan scroll | 60 fps (frame ≤ 16 ms) di perangkat menengah | Flutter DevTools → Performance |
| Jank (frame lambat) | Kurang dari 1% frame saat scroll Beranda | DevTools, mode **profile** |
| Waktu dari peluncuran sampai Splash tampil | Kurang dari 2 detik | `flutter run --profile` + stopwatch |
| Pindah tab | Instan (kurang dari 100 ms) | Pengamatan + DevTools |
| Foto muncul (jaringan baik) | Kurang dari 2 detik per foto | Pengamatan |
| Ukuran APK release | Di bawah 25 MB | `flutter build apk --analyze-size` |
| Penggunaan memori | Stabil, tanpa kenaikan terus-menerus | DevTools → Memory |
| Overflow / error layout | 0 | Konsol dan `flutter analyze` |

## 2. Kondisi Saat Ini

### 2.1 Yang sudah baik

| Praktik | Dampak |
|---|---|
| Widget `const` di banyak tempat | Mengurangi pembuatan ulang widget |
| Daftar tab `const` di `MainShell` | Pergantian tab tidak membangun ulang objek tab yang sama dari awal |
| Tanpa paket pihak ketiga | APK kecil, startup ringan |
| Semua foto diminta dalam format **WebP** (`fm=webp`) dengan `w=700&q=70` | Ukuran unduhan umumnya jauh lebih kecil daripada JPEG/PNG pada kualitas yang mirip; foto muncul lebih cepat dan hemat kuota |
| Kelas widget kecil dan terpisah | `setState` hanya membangun ulang bagian yang perlu |
| `setState` hanya di 3 widget (`PreferencePage`, `MainShell`, `RestaurantPage`) | Cakupan rebuild terbatas |
| Hanya 4 restoran dan 12 menu | Tidak perlu lazy loading untuk saat ini |

### 2.2 Potensi masalah

| # | Temuan | Risiko | Tingkat |
|---|---|---|---|
| P1 | `Image.network` tanpa `cacheWidth` / `cacheHeight` | Gambar didekode dalam ukuran penuh (700 px) meski ditampilkan kecil (56–110 dp); memori lebih besar | Sedang |
| P2 | Tidak ada cache disk untuk gambar | Foto diunduh ulang setiap aplikasi dibuka; boros kuota | Sedang |
| P3 | Tidak ada `loadingBuilder` | Area foto kosong saat memuat; terasa lambat | Sedang |
| P4 | `ListView(children: [...])` membuat semua widget anak sekaligus | Tidak masalah untuk 4 restoran, tetapi tidak skalabel | Rendah (naik jika data bertambah) |
| P5 | Foto yang sama dimuat banyak kali dari URL berbeda ukuran | Unduhan berulang | Rendah |
| P6 | `DecorationImage` memakai `NetworkImage` tanpa penanganan error | Pengecualian di konsol bila gagal; latar tetap oranye atau gelap | Rendah |
| P7 | `MainShell` memakai `tabs[index]` (tab tidak dipertahankan) | Posisi scroll tab hilang saat berpindah | Rendah (UX) |
| P8 | Banyak `BoxShadow` dengan blur besar pada daftar kartu | Dapat memberatkan perangkat lama saat scroll panjang | Rendah |

## 3. Optimasi yang Disarankan

### 3.0 Format gambar WebP (sudah diterapkan)

Semua foto memakai **WebP**. Flutter mendukung WebP di Android, iOS, dan Web.

| Sumber foto | Cara memakai WebP |
|---|---|
| Jaringan (Unsplash) | Parameter `fm=webp` pada fungsi `img()`: `...?fm=webp&fit=crop&w=700&q=70` |
| Aset lokal | File berekstensi `.webp` di `assets/images/`, dimuat dengan `Image.asset` |

Konversi foto sendiri (pilih salah satu):

```bash
# cwebp (paket libwebp)
cwebp -q 75 -resize 700 0 foto.jpg -o foto.webp

# ImageMagick
magick foto.jpg -resize 700x -quality 75 foto.webp
```

Cara memeriksa bahwa foto benar-benar WebP:
1. Jalankan aplikasi dengan `flutter run --profile`, lalu buka **DevTools → Network**.
2. Pilih salah satu permintaan ke `images.unsplash.com`.
3. Pastikan header respons `content-type` bernilai `image/webp`.
4. Untuk aset lokal, pastikan semua file di `assets/images/` berakhiran `.webp`.

> WebP mengurangi **ukuran unduhan**, tetapi tidak mengurangi memori setelah gambar didekode. Untuk memori, pakai `cacheWidth` (bagian 3.1).

### 3.1 Kurangi memori gambar (P1)
```dart
Image.network(
  url,
  width: w,
  height: h,
  fit: BoxFit.cover,
  cacheWidth: w != null && w.isFinite ? (w * 2).round() : 800, // ±2x untuk layar tajam
)
```
> Atur `cacheWidth` sesuai ukuran tampilan. Jangan dipakai bila `w` bernilai `double.infinity`.

### 3.2 Tampilkan indikator saat memuat (P3)
```dart
Image.network(
  url,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return Container(
      width: w,
      height: h,
      color: const Color(0xFFFFEEE8),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: kOrange),
        ),
      ),
    );
  },
)
```

### 3.3 Cache gambar di disk (P2)
Tambahkan paket `cached_network_image` pada `pubspec.yaml`, lalu ganti `Image.network` di widget `Photo`. Ini opsional dan menambah satu dependensi.

### 3.4 Daftar yang lazy (P4)
Jika data restoran bertambah banyak, ganti `ListView(children: ...)` dengan:
```dart
ListView.builder(
  itemCount: restaurants.length,
  itemBuilder: (context, i) => RestaurantCard(restaurants[i]),
)
```

### 3.5 Pertahankan posisi scroll antartab (P7)
```dart
body: SafeArea(
  bottom: false,
  child: IndexedStack(index: index, children: tabs),
)
```
> `IndexedStack` membangun semua tab sekaligus. Cocok untuk 4 tab ringan.

### 3.6 Praktik umum
- Tambahkan `const` pada widget yang nilainya tetap.
- Jangan membuat objek berat di dalam `build()`.
- Gunakan `RepaintBoundary` hanya jika DevTools menunjukkan repaint berlebihan.
- Hindari `Opacity` dan `ClipRRect` bertingkat di daftar panjang.
- Jalankan pengujian performa di **mode profile**, bukan debug.

## 4. Cara Mengukur

```bash
# 1. Jalankan di perangkat nyata, mode profile
flutter run --profile

# 2. Buka DevTools dari konsol (tautan akan muncul), lalu cek:
#    - Performance: grafik frame (hijau = baik, merah = jank)
#    - Memory: kenaikan memori saat scroll Beranda
#    - CPU Profiler: fungsi yang paling berat

# 3. Ukuran APK
flutter build apk --analyze-size

# 4. Kualitas kode
flutter analyze
```

> **Penting:** mode debug jauh lebih lambat dari rilis. Jangan menilai performa dari mode debug.

### Skenario uji
| # | Skenario | Yang diamati |
|---|---|---|
| S1 | Buka aplikasi sampai Splash tampil | Waktu mulai |
| S2 | Scroll cepat naik-turun di Beranda | Jank, memori |
| S3 | Pindah antar-4-tab berulang kali | Kelancaran, posisi scroll |
| S4 | Buka Detail Restoran, tekan **+** 20 kali | Rebuild, respons |
| S5 | Matikan internet, buka Beranda | Fallback gambar, tidak crash |
| S6 | Koneksi lambat (throttle 3G) | Perilaku saat memuat |

## 5. Anggaran Performa (Performance Budget)

| Sumber daya | Batas |
|---|---|
| Format dan ukuran gambar per foto | WebP, ≤ 150 KB |
| Jumlah dependensi | 0 (atau maksimal 1–2 bila ada cache gambar) |
| Kedalaman widget per halaman | Wajar; hindari bersarang lebih dari ±15 tingkat tanpa memecah widget |
| Rebuild per ketukan | Hanya widget yang berubah |

## 6. Rencana Perbaikan

| Prioritas | Tugas | Terkait |
|---|---|---|
| 0 | ✅ Semua foto memakai format WebP | Bagian 3.0 |
| 1 | Tambah `loadingBuilder` pada `Photo` | P3 |
| 2 | Tambah `cacheWidth` pada gambar kecil | P1 |
| 3 | Fallback untuk `DecorationImage` | P6 |
| 4 | Ganti ke `ListView.builder` saat data membesar | P4 |
| 5 | Pertimbangkan `cached_network_image` | P2 |
| 6 | Pakai `IndexedStack` bila posisi scroll perlu dipertahankan | P7 |

## 7. Tabel Hasil Pengukuran (Isi Sendiri)

| Metrik | Target | Hasil | Perangkat | Tanggal | Lulus? |
|---|---|---|---|---|---|
| Waktu sampai Splash | < 2 dtk | | | | |
| Rata-rata waktu frame (Beranda) | ≤ 16 ms | | | | |
| Frame jank (Beranda) | < 1% | | | | |
| Ukuran APK release | < 25 MB | | | | |
| Memori setelah scroll 1 menit | Stabil | | | | |
| `flutter analyze` | 0 error | | | | |
