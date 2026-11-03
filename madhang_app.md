# 🍛 MADHANG — Food Ordering App (Flutter)

*"Madhang" means "to eat" in Javanese.* MADHANG is a food ordering app with an orange, photo-led mobile UI inspired by your reference (Purxx): dark splash, login, "what do you like to eat?" picker, home feed with bottom navigation, restaurant detail, checkout, and profile stats.

---

## 1. Why the Old UI Looked Like a Web App (and What Changed)

| Web-app feel (before) | App feel (now) |
|---|---|
| One long scrolling page with sections (landing page) | **Separate full-screen pages** with a clear purpose each |
| No persistent navigation | **Bottom navigation bar** (Home, Favorit, Pesanan, Profil) |
| Wide content, centered on a desktop-width screen | Width **capped at 430 dp** and phone-sized layouts, even in Chrome |
| Plain buttons, no touch feedback | Large rounded buttons with **ripple (`InkWell`)** and 48 dp+ tap targets |
| Default app bars on every page | **Custom headers** inside `SafeArea`, image headers with floating back buttons |
| Hard page edges | Rounded cards, soft shadows, rounded bottom bar |
| Mouse-style scrolling | **`BouncingScrollPhysics`**, portrait lock, transparent status bar |
| "Back" text buttons | Circular back icons and **sticky bottom action buttons** |
| Back button returns to login after signing in | **`pushAndRemoveUntil`** clears the stack once the user is in the app |

## 2. Reference to MADHANG Screen Mapping

| Reference screen (Purxx) | MADHANG screen | Class |
|---|---|---|
| Dark splash with food photos | Splash | `SplashPage` |
| Login (business or member) | Login | `LoginPage` |
| "What do you like to eat?" grid | Food preferences (select categories) | `PreferencePage` |
| Home / listing with bottom nav | Home feed + 3 more tabs | `MainShell`, `HomeTab`, `FavoritesTab`, `OrdersTab`, `ProfileTab` |
| Business listing detail | Restaurant menu | `RestaurantPage` |
| Orange "Redeem" offer card | Checkout summary and order button | `CheckoutPage` |
| Orange confirmation/upgrade screen | Order success | `SuccessPage` |
| Profile analytics (big numbers) | Profile stats | `ProfileTab` |

## 3. Design System

| Token | Value | Use |
|---|---|---|
| `kOrange` | `#FF5A2D` | Primary buttons, active tab, prices, accents |
| `kInk` | `#1E1E22` | Splash background, headings |
| `kGrey` | `#8A8A93` | Secondary text, inactive icons |
| `kField` | `#F4F4F6` | Search bar, text fields, stat cards |
| Radius | 16–27 | Cards 22, fields 16, buttons 27 (pill) |
| Spacing | 4 · 8 · 12 · 16 · 20 · 24 | Consistent gaps |
| Typography | Bold titles 24–28, body 13–15, captions 11–12 | Default Flutter font |

## 4. App Flow

```
SplashPage ─push─► LoginPage ─push─► PreferencePage ─pushAndRemoveUntil─► MainShell
                                                                          ├─ Home
                                                                          ├─ Favorit
                                                                          ├─ Pesanan
                                                                          └─ Profil
                                                                               │
Home / Favorit ─push─► RestaurantPage ─push─► CheckoutPage ─push─► SuccessPage
                              ▲ pop               ▲ pop                │
                                                            popUntil(first) ─► MainShell
```

**7 routes, 10 screens** (6 pages plus the 4 tabs that live inside `MainShell`).

## 5. Course Requirements Checklist

| Requirement | Where |
|---|---|
| Text, TextStyle, Icon, Color, Container | All pages; palette constants; styled containers |
| Row, Column, combinations | `RestaurantCard`, dish rows, stat cards, nav bar |
| Margin, padding, SizedBox | Card `margin`, page `padding`, `SizedBox` gaps |
| Image + size + BoxFit | `Photo` widget: `Image.network(width, height, fit: BoxFit.cover)` plus `DecorationImage` |
| Image format | **WebP** for every photo (`fm=webp` in the URL, or `.webp` files with `Image.asset`) |
| 5+ pages, `Navigator.push()` / `pop()` | 7 routes; `push`, `pop`, plus `pushAndRemoveUntil` and `popUntil` |

> `PreferencePage`, `MainShell`, and `RestaurantPage` are `StatefulWidget`s (selection, tab index, quantities) and use `setState`. Everything else is stateless.

## 6. Quick Setup

```bash
flutter create madhang
cd madhang
# replace lib/main.dart with the code in section 7
flutter run            # or: flutter run -d chrome
```

Replace `test/widget_test.dart` with `void main() {}`. No packages are needed. For the full environment setup, see `madhang_setup_guide.md`. For Android **release** builds add `<uses-permission android:name="android.permission.INTERNET"/>` to `AndroidManifest.xml`.

---

## 7. Source Code — `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // App feel: portrait only + transparent status bar
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MadhangApp());
}

// ------------------------------------------------------------
// THEME + HELPERS
// ------------------------------------------------------------
const Color kOrange = Color(0xFFFF5A2D);
const Color kInk = Color(0xFF1E1E22);
const Color kGrey = Color(0xFF8A8A93);
const Color kField = Color(0xFFF4F4F6);

// Every photo is requested as WebP (fm=webp): smaller downloads, faster loading.
String img(String id) =>
    'https://images.unsplash.com/photo-$id?fm=webp&fit=crop&w=700&q=70';

String rp(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

void go(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

// Opens a page and removes every page before it (no going back to login)
void goRoot(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

// ------------------------------------------------------------
// DATA
// ------------------------------------------------------------
class Dish {
  final String name, desc, image;
  final int price;
  const Dish(this.name, this.desc, this.price, this.image);
}

class Restaurant {
  final String name, cuisine, image, distance, time;
  final double rating;
  final int fee;
  final List<Dish> menu;
  const Restaurant(this.name, this.cuisine, this.image, this.distance,
      this.time, this.rating, this.fee, this.menu);
}

class CartLine {
  final Dish dish;
  final int qty;
  const CartLine(this.dish, this.qty);
}

final List<List<String>> categories = [
  ['Nasi', '1512058564366-18510be2db19'],
  ['Ayam', '1544025162-d76694265947'],
  ['Sate', '1555939594-58d7cb561ad1'],
  ['Bakso', '1569718212165-3a8278d5f624'],
  ['Mie', '1540189549336-e6e99c3679fe'],
  ['Salad', '1546069901-ba9599a7e63c'],
  ['Burger', '1529042410759-befb1204b468'],
  ['Dessert', '1565958011703-44f9829ba187'],
];

final List<Restaurant> restaurants = [
  Restaurant('Warung Madhang Bu Tini', 'Masakan Jawa',
      img('1504674900247-0877df9cc836'), '1.2 km', '20-30 min', 4.8, 8000, [
    Dish('Nasi Pecel Komplit', 'Sayur segar, bumbu kacang, tempe, rempeyek',
        18000, img('1540189549336-e6e99c3679fe')),
    Dish('Ayam Goreng Kremes', 'Ayam empuk dengan kremesan renyah', 25000,
        img('1544025162-d76694265947')),
    Dish('Es Teh Manis', 'Teh dingin segar', 6000,
        img('1476224203421-9ac39bcb3327')),
  ]),
  Restaurant('Sate Pak Kumis', 'Sate & Grill', img('1555939594-58d7cb561ad1'),
      '2.0 km', '25-35 min', 4.7, 10000, [
    Dish('Sate Ayam (10 tusuk)', 'Bumbu kacang dan lontong', 28000,
        img('1555939594-58d7cb561ad1')),
    Dish('Sate Kambing', 'Dibakar arang, kecap manis', 35000,
        img('1544025162-d76694265947')),
    Dish('Lontong', 'Pelengkap sate', 6000, img('1512058564366-18510be2db19')),
  ]),
  Restaurant('Bakso Mas Joko', 'Bakso & Mie', img('1569718212165-3a8278d5f624'),
      '0.8 km', '15-25 min', 4.9, 6000, [
    Dish('Bakso Urat Jumbo', 'Kuah kaldu sapi gurih', 22000,
        img('1569718212165-3a8278d5f624')),
    Dish('Mie Ayam Spesial', 'Ayam cincang, pangsit, bakso', 20000,
        img('1540189549336-e6e99c3679fe')),
    Dish('Es Jeruk', 'Jeruk peras asli', 8000, img('1476224203421-9ac39bcb3327')),
  ]),
  Restaurant('Nasi Goreng Kang Ujang', 'Nasi & Mie Goreng',
      img('1512058564366-18510be2db19'), '1.6 km', '20-30 min', 4.6, 7000, [
    Dish('Nasi Goreng Spesial', 'Telur, ayam, kerupuk', 24000,
        img('1512058564366-18510be2db19')),
    Dish('Mie Goreng Jawa', 'Bumbu manis pedas khas Jawa', 22000,
        img('1540189549336-e6e99c3679fe')),
    Dish('Kerupuk', 'Renyah dan gurih', 5000, img('1504674900247-0877df9cc836')),
  ]),
];

// ------------------------------------------------------------
// APP
// ------------------------------------------------------------
class MadhangApp extends StatelessWidget {
  const MadhangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MADHANG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kOrange),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Keeps the layout phone-sized even on Chrome / tablets
      builder: (context, child) => Container(
        color: const Color(0xFFE9EBF0),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
      home: const SplashPage(),
    );
  }
}

// ------------------------------------------------------------
// REUSABLE WIDGETS
// ------------------------------------------------------------
class Photo extends StatelessWidget {
  final String url;
  final double? w;
  final double h, r;
  const Photo(this.url, {super.key, this.w, required this.h, this.r = 16});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Image.network(
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
      ),
    );
  }
}

class OrangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const OrangeButton(this.label, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        boxShadow: const [
          BoxShadow(color: Color(0x55FF5A2D), blurRadius: 14, offset: Offset(0, 6))
        ],
      ),
      child: Material(
        color: kOrange,
        borderRadius: BorderRadius.circular(27),
        child: InkWell(
          borderRadius: BorderRadius.circular(27),
          onTap: onTap,
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: Center(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const RoundIcon(this.icon, this.onTap, {super.key, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: filled ? kOrange : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Icon(icon, size: 20, color: filled ? Colors.white : kInk),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  const AppField(this.hint, this.icon, {super.key, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: kGrey),
        filled: true,
        fillColor: kField,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const CategoryChip(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: const Color(0xFFFFEEE8),
              borderRadius: BorderRadius.circular(20)),
          child: Icon(icon, color: kOrange, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant r;
  const RestaurantCard(this.r, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => go(context, RestaurantPage(r: r)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Photo(r.image, w: double.infinity, h: 150, r: 18),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(r.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: kInk)),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF3D6),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text('${r.rating}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(r.cuisine,
                      style: const TextStyle(fontSize: 13, color: kGrey)),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.timer_outlined, size: 16, color: kOrange),
                    const SizedBox(width: 4),
                    Text(r.time, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 14),
                    const Icon(Icons.near_me_outlined, size: 16, color: kOrange),
                    const SizedBox(width: 4),
                    Text(r.distance, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 14),
                    const Icon(Icons.delivery_dining, size: 18, color: kOrange),
                    const SizedBox(width: 4),
                    Text(rp(r.fee), style: const TextStyle(fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const SummaryRow(this.label, this.value, {super.key, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: bold ? 18 : 14,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: bold ? kOrange : kInk);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const TabPage(this.title, this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: kInk)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

// ------------------------------------------------------------
// PAGE 1 - SPLASH
// ------------------------------------------------------------
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInk,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: Photo(img('1504674900247-0877df9cc836'), h: 130, r: 24)),
                const SizedBox(width: 12),
                Expanded(child: Photo(img('1555939594-58d7cb561ad1'), h: 130, r: 24)),
              ]),
              const Spacer(),
              const Text('MADHANG',
                  style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                      color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Pesan makanan favoritmu,\ncepat sampai di rumah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.4, color: Colors.white70)),
              const Spacer(),
              Row(children: [
                Expanded(child: Photo(img('1569718212165-3a8278d5f624'), h: 130, r: 24)),
                const SizedBox(width: 12),
                Expanded(child: Photo(img('1512058564366-18510be2db19'), h: 130, r: 24)),
              ]),
              const SizedBox(height: 24),
              OrangeButton('Mulai', () => go(context, const LoginPage())),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 2 - LOGIN
// ------------------------------------------------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Widget social(IconData icon) => Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(color: kField, shape: BoxShape.circle),
        child: Icon(icon, color: kInk),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: kInk,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(36)),
                image: DecorationImage(
                  image: NetworkImage(img('1504674900247-0877df9cc836')),
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: const Text('MADHANG',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat datang!',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold, color: kInk)),
                  const SizedBox(height: 4),
                  const Text('Masuk untuk mulai memesan makanan.',
                      style: TextStyle(color: kGrey)),
                  const SizedBox(height: 24),
                  const AppField('Email', Icons.mail_outline),
                  const SizedBox(height: 14),
                  const AppField('Password', Icons.lock_outline, obscure: true),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Lupa password?',
                        style: TextStyle(color: kOrange, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),
                  OrangeButton('Masuk', () => go(context, const PreferencePage())),
                  const SizedBox(height: 22),
                  const Center(child: Text('atau', style: TextStyle(color: kGrey))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      social(Icons.g_mobiledata),
                      const SizedBox(width: 16),
                      social(Icons.facebook),
                      const SizedBox(width: 16),
                      social(Icons.apple),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Text.rich(TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: kGrey),
                      children: [
                        TextSpan(
                            text: 'Daftar',
                            style: TextStyle(
                                color: kOrange, fontWeight: FontWeight.bold)),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 3 - FOOD PREFERENCES
// ------------------------------------------------------------
class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final Set<String> picked = {};

  Widget tile(List<String> c) {
    final on = picked.contains(c[0]);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (on) {
            picked.remove(c[0]);
          } else {
            picked.add(c[0]);
          }
        });
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: kInk,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? kOrange : Colors.transparent, width: 3),
          image: DecorationImage(
            image: NetworkImage(img(c[1])),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Row(children: [
          Expanded(
            child: Text(c[0],
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          if (on) const Icon(Icons.check_circle, color: kOrange),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < categories.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Expanded(child: tile(categories[i])),
          const SizedBox(width: 12),
          Expanded(child: tile(categories[i + 1])),
        ]),
      ));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Kamu suka\nmakan apa?',
                      style: TextStyle(
                          fontSize: 30,
                          height: 1.15,
                          fontWeight: FontWeight.bold,
                          color: kInk)),
                  const SizedBox(height: 6),
                  Text('${picked.length} dipilih • pilih sebanyak yang kamu mau',
                      style: const TextStyle(color: kGrey)),
                  const SizedBox(height: 20),
                  ...rows,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kOrange,
                      side: const BorderSide(color: kOrange),
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27)),
                    ),
                    onPressed: () => goRoot(context, const MainShell()),
                    child: const Text('Lewati'),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => goRoot(context, const MainShell()),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration:
                        const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 4 - MAIN SHELL (bottom navigation)
// ------------------------------------------------------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final List<Widget> tabs = const [
    HomeTab(),
    FavoritesTab(),
    OrdersTab(),
    ProfileTab(),
  ];

  Widget navItem(int i, IconData icon, String label) {
    final on = index == i;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => index = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: on ? kOrange : kGrey),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: on ? kOrange : kGrey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: false, child: tabs[index]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(children: [
            navItem(0, Icons.home_rounded, 'Beranda'),
            navItem(1, Icons.favorite_rounded, 'Favorit'),
            navItem(2, Icons.receipt_long_rounded, 'Pesanan'),
            navItem(3, Icons.person_rounded, 'Profil'),
          ]),
        ),
      ),
    );
  }
}

// ---------- Tab: Home ----------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dikirim ke', style: TextStyle(fontSize: 12, color: kGrey)),
                SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.location_on, color: kOrange, size: 18),
                  SizedBox(width: 4),
                  Text('Rumah • Jl. Melati No. 5',
                      style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
                ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: kField, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none, color: kInk),
          ),
        ]),
        const SizedBox(height: 18),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: kField, borderRadius: BorderRadius.circular(25)),
          child: const Row(children: [
            Icon(Icons.search, color: kGrey),
            SizedBox(width: 10),
            Text('Cari makanan atau restoran', style: TextStyle(color: kGrey)),
          ]),
        ),
        const SizedBox(height: 20),

        // Promo banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: kOrange, borderRadius: BorderRadius.circular(24)),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PROMO HARI INI',
                      style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70)),
                  const SizedBox(height: 6),
                  const Text('Diskon 50%\nmakan siang',
                      style: TextStyle(
                          fontSize: 24,
                          height: 1.15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Klaim',
                        style: TextStyle(
                            color: kOrange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Photo(img('1504674900247-0877df9cc836'), w: 110, h: 110, r: 55),
          ]),
        ),
        const SizedBox(height: 22),

        // Categories
        SizedBox(
          height: 92,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: const [
              CategoryChip(Icons.rice_bowl, 'Nasi'),
              CategoryChip(Icons.lunch_dining, 'Burger'),
              CategoryChip(Icons.ramen_dining, 'Mie'),
              CategoryChip(Icons.set_meal, 'Seafood'),
              CategoryChip(Icons.local_drink, 'Minuman'),
              CategoryChip(Icons.cake, 'Dessert'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Row(children: [
          Expanded(
            child: Text('Terdekat dari kamu',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: kInk)),
          ),
          Text('Lihat semua',
              style: TextStyle(color: kOrange, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 14),
        ...restaurants.map((r) => RestaurantCard(r)),
      ],
    );
  }
}

// ---------- Tab: Favorites ----------
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = restaurants.where((r) => r.rating >= 4.7).toList();
    return TabPage('Favorit', favs.map((r) => RestaurantCard(r)).toList());
  }
}

// ---------- Tab: Orders ----------
class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  Widget order(Restaurant r, String info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 5))
        ],
      ),
      child: Row(children: [
        Photo(r.image, w: 68, h: 68, r: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: kInk)),
              const SizedBox(height: 3),
              Text(info, style: const TextStyle(fontSize: 12, color: kGrey)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0x2200A650),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Selesai',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A650))),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: kGrey),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabPage('Pesanan', [
      order(restaurants[0], '2 item • Rp 51.000 • 28 Okt'),
      order(restaurants[2], '1 item • Rp 28.000 • 25 Okt'),
      order(restaurants[1], '3 item • Rp 73.000 • 19 Okt'),
    ]);
  }
}

// ---------- Tab: Profile ----------
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Widget stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: kField, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, color: kOrange)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: kGrey)),
          ],
        ),
      ),
    );
  }

  Widget menuRow(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          Icon(icon, color: kInk),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          const Icon(Icons.chevron_right, color: kGrey),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabPage('Profil', [
      Row(children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
          child: const Text('A',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Andi Pratama',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: kInk)),
              SizedBox(height: 2),
              Text('andi@email.com', style: TextStyle(color: kGrey)),
            ],
          ),
        ),
      ]),
      const SizedBox(height: 22),
      Row(children: [
        stat('24', 'Pesanan'),
        const SizedBox(width: 12),
        stat('8', 'Favorit'),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        stat('3', 'Voucher'),
        const SizedBox(width: 12),
        stat('1.250', 'Poin'),
      ]),
      const SizedBox(height: 14),
      menuRow(Icons.location_on_outlined, 'Alamat tersimpan', () {}),
      menuRow(Icons.account_balance_wallet_outlined, 'Metode pembayaran', () {}),
      menuRow(Icons.help_outline, 'Bantuan', () {}),
      menuRow(Icons.logout, 'Keluar', () => goRoot(context, const SplashPage())),
    ]);
  }
}

// ------------------------------------------------------------
// PAGE 5 - RESTAURANT DETAIL
// ------------------------------------------------------------
class RestaurantPage extends StatefulWidget {
  final Restaurant r;
  const RestaurantPage({super.key, required this.r});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final Map<int, int> qty = {};

  List<CartLine> get lines => [
        for (int i = 0; i < widget.r.menu.length; i++)
          if ((qty[i] ?? 0) > 0) CartLine(widget.r.menu[i], qty[i]!),
      ];
  int get count => lines.fold(0, (sum, l) => sum + l.qty);
  int get total => lines.fold(0, (sum, l) => sum + l.dish.price * l.qty);

  Widget qtyButton(IconData icon, VoidCallback onTap, {bool filled = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled ? kOrange : kField,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: filled ? Colors.white : kInk),
      ),
    );
  }

  Widget dishRow(int i) {
    final d = widget.r.menu[i];
    final q = qty[i] ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Photo(d.image, w: 84, h: 84, r: 18),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(d.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: kInk)),
              const SizedBox(height: 3),
              Text(d.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: kGrey)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: Text(rp(d.price),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: kOrange)),
                ),
                if (q == 0)
                  qtyButton(Icons.add, () => setState(() => qty[i] = 1))
                else
                  Row(children: [
                    qtyButton(Icons.remove, () => setState(() => qty[i] = q - 1),
                        filled: false),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('$q',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    qtyButton(Icons.add, () => setState(() => qty[i] = q + 1)),
                  ]),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Image header with floating buttons
          Container(
            height: 250,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3DA),
              image: DecorationImage(
                  image: NetworkImage(r.image), fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(children: [
                  RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
                  const Spacer(),
                  RoundIcon(Icons.favorite_border, () {}),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: kInk)),
                const SizedBox(height: 4),
                Text(r.cuisine, style: const TextStyle(color: kGrey)),
                const SizedBox(height: 14),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('${r.rating}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 18),
                  const Icon(Icons.timer_outlined, color: kOrange, size: 18),
                  const SizedBox(width: 4),
                  Text(r.time),
                  const SizedBox(width: 18),
                  const Icon(Icons.near_me_outlined, color: kOrange, size: 18),
                  const SizedBox(width: 4),
                  Text(r.distance),
                ]),
                const SizedBox(height: 24),
                const Text('Menu',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
                const SizedBox(height: 16),
                for (int i = 0; i < r.menu.length; i++) dishRow(i),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: count == 0
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
              ),
              child: SafeArea(
                child: OrangeButton(
                  'Lihat Keranjang • $count item • ${rp(total)}',
                  () => go(context, CheckoutPage(r: r, lines: lines)),
                ),
              ),
            ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 6 - CHECKOUT
// ------------------------------------------------------------
class CheckoutPage extends StatelessWidget {
  final Restaurant r;
  final List<CartLine> lines;
  const CheckoutPage({super.key, required this.r, required this.lines});

  @override
  Widget build(BuildContext context) {
    final subtotal = lines.fold(0, (sum, l) => sum + l.dish.price * l.qty);
    final total = subtotal + r.fee;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(children: [
                RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
                const SizedBox(width: 14),
                const Text('Pesanan Saya',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
              ]),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: kField, borderRadius: BorderRadius.circular(18)),
                    child: const Row(children: [
                      Icon(Icons.location_on, color: kOrange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alamat pengiriman',
                                style: TextStyle(fontSize: 12, color: kGrey)),
                            SizedBox(height: 2),
                            Text('Rumah • Jl. Melati No. 5',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  Text(r.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold, color: kInk)),
                  const SizedBox(height: 12),
                  for (final l in lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Photo(l.dish.image, w: 56, h: 56, r: 14),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.dish.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('x${l.qty}',
                                  style: const TextStyle(color: kGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(rp(l.dish.price * l.qty),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  const Divider(height: 32),
                  SummaryRow('Subtotal', rp(subtotal)),
                  SummaryRow('Ongkos kirim', rp(r.fee)),
                  const Divider(height: 24),
                  SummaryRow('Total', rp(total), bold: true),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E5EA)),
                        borderRadius: BorderRadius.circular(18)),
                    child: const Row(children: [
                      Icon(Icons.account_balance_wallet_outlined, color: kOrange),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text('Bayar di tempat (COD)',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      Icon(Icons.check_circle, color: kOrange),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: OrangeButton('Pesan Sekarang • ${rp(total)}',
                  () => go(context, SuccessPage(total: total))),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 7 - SUCCESS
// ------------------------------------------------------------
class SuccessPage extends StatelessWidget {
  final int total;
  const SuccessPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final no = 'MDH-${DateTime.now().millisecondsSinceEpoch % 100000}';

    return Scaffold(
      backgroundColor: kOrange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration:
                    const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 70, color: kOrange),
              ),
              const SizedBox(height: 26),
              const Text('Pesanan diterima!',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Restoran sedang menyiapkan makananmu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(children: [
                  SummaryRow('No. pesanan', no),
                  const SummaryRow('Estimasi tiba', '25-30 menit'),
                  SummaryRow('Total', rp(total), bold: true),
                ]),
              ),
              const Spacer(),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(27),
                child: InkWell(
                  borderRadius: BorderRadius.circular(27),
                  // Pop every page until the first one (MainShell)
                  onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: Center(
                      child: Text('Kembali ke Beranda',
                          style: TextStyle(
                              color: kOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Test the Flow

| # | Action | Expected result |
|---|---|---|
| 1 | Launch | Dark splash with four photos and **MADHANG** logo |
| 2 | Tap **Mulai** | Login page |
| 3 | Tap **Masuk** | "Kamu suka makan apa?" grid; tapping a tile adds an orange border and check |
| 4 | Tap **Lewati** (or the arrow) | Home with bottom nav; pressing back does **not** return to login |
| 5 | Switch tabs | Beranda, Favorit, Pesanan, Profil all show content |
| 6 | Tap a restaurant card | Detail page with image header and menu |
| 7 | Tap **+** on dishes | Quantity appears; bottom bar shows item count and total |
| 8 | Tap **Lihat Keranjang** | Checkout with subtotal, delivery fee, total |
| 9 | Tap back arrow | Returns to the menu (`pop`) |
| 10 | Tap **Pesan Sekarang** | Orange success screen with order number |
| 11 | Tap **Kembali ke Beranda** | Returns to the Home tab (`popUntil`) |
| 12 | Profil → **Keluar** | Back to splash; stack cleared |

## 9. Notes and Customization

- **Photos (WebP):** all network photos are requested as WebP through `fm=webp` in `img()`, which keeps downloads small. Unsplash links aren't checked; if one is wrong or broken, a fallback icon is shown. Swap IDs in `restaurants` and `categories`.
- **Local WebP photos:** to work offline, convert photos to `.webp`, put them in `assets/images/`, register the folder in `pubspec.yaml`, and use `Image.asset` / `AssetImage`. Steps are in `madhang_setup_guide.md`, section 9.
- **Name and colors:** change `kOrange` to retheme the whole app.
- **Pages:** `LoginPage` does no real authentication. It simply navigates forward.
- **Optional next steps:** a working search, a multi-restaurant cart, order status tracking, and splitting the code into `models/`, `widgets/`, and `pages/` folders.
