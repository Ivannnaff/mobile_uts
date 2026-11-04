import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/food_item.dart';
import '../widgets/custom_widgets.dart';
import 'about_page.dart';
import 'help_page.dart';
import 'login_page.dart';

// ==========================================
// HALAMAN UTAMA (BOTTOM NAVIGATION)
// ==========================================
class MainShell extends StatefulWidget {
  final String nama, meja;
  const MainShell({super.key, required this.nama, required this.meja});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  late final List<Widget> tabs = [
    HomeTab(nama: widget.nama, meja: widget.meja),
    FavoritesTab(nama: widget.nama),
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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: Row(children: [
            navItem(0, Icons.restaurant_menu_rounded, 'Menu'),
            navItem(1, Icons.favorite_rounded, 'Favorit'),
          ]),
        ),
      ),
    );
  }
}

// ==========================================
// TAB MENU (dengan filter kategori)
// ==========================================
class HomeTab extends StatefulWidget {
  final String nama, meja;
  const HomeTab({super.key, required this.nama, required this.meja});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == 'Semua'
        ? menuItems
        : menuItems.where((i) => i.category == selectedCategory).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pemesanan di Tempat',
                      style: TextStyle(fontSize: 12, color: kGrey)),
                  const SizedBox(height: 2),
                  Text('Meja ${widget.meja} • ${widget.nama}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: kInk, fontSize: 16)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: kField, shape: BoxShape.circle),
              child: const Icon(Icons.table_restaurant, color: kOrange),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Banner Promo Dine-In
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(24)),
          child: Row(children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PROMO DINE-IN',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
                  SizedBox(height: 6),
                  Text('Gratis Es Teh\nuntuk semua menu',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            Photo(img('1476224203421-9ac39bcb3327'), w: 90, h: 90, r: 45),
          ]),
        ),
        const SizedBox(height: 20),
        // Filter Kategori
        Row(
          children: ['Semua', 'Makanan', 'Snack', 'Minuman'].map((cat) {
            final active = selectedCategory == cat;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedCategory = cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? kOrange : kField,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(cat,
                      style: TextStyle(
                          color: active ? Colors.white : kInk,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text('Daftar Menu ($selectedCategory)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kInk)),
        const SizedBox(height: 14),
        ...filtered.map((item) => FoodCard(item)),
      ],
    );
  }
}

// ==========================================
// TAB FAVORIT
// ==========================================
class FavoritesTab extends StatelessWidget {
  final String nama;
  const FavoritesTab({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    final favs = menuItems.take(3).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Menu Favorit',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kInk)),
                  const SizedBox(height: 2),
                  Text('Halo, $nama', style: const TextStyle(fontSize: 13, color: kGrey)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: kOrange),
              onPressed: () => go(context, const HelpPage()),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: kOrange),
              onPressed: () => go(context, const AboutPage()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...favs.map((item) => FoodCard(item)),
        const SizedBox(height: 16),
        OrangeButton('Ganti Meja / Nama', () => goRoot(context, const LoginPage())),
      ],
    );
  }
}
