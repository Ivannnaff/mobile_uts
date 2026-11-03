import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/food_item.dart';
import '../pages/detail_menu_page.dart';

// 1. Widget Gambar (Image.network + BoxFit)
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

// 2. Tombol Oranye Utama
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

// 3. Tombol Bulat untuk Back
class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const RoundIcon(this.icon, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Icon(icon, size: 20, color: kInk),
      ),
    );
  }
}

// 4. Input TextField
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

// 5. Kartu Menu (bisa diklik menuju Detail)
class FoodCard extends StatelessWidget {
  final FoodItem item;
  const FoodCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => go(context, DetailMenuPage(item: item)),
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
        child: Row(
          children: [
            Photo(item.image, w: 90, h: 90, r: 16),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEE8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item.category,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold, color: kOrange)),
                  ),
                  const SizedBox(height: 4),
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: kInk)),
                  const SizedBox(height: 3),
                  Text(item.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: kGrey)),
                  const SizedBox(height: 8),
                  Text(rp(item.price),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: kOrange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
