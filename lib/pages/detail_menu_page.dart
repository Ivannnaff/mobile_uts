import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/food_item.dart';
import '../widgets/custom_widgets.dart';

class DetailMenuPage extends StatelessWidget {
  final FoodItem item;
  const DetailMenuPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3DA),
              image: DecorationImage(
                image: NetworkImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(item.category,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: kOrange, fontSize: 12)),
                ),
                const SizedBox(height: 10),
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold, color: kInk)),
                const SizedBox(height: 8),
                Text(rp(item.price),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: kOrange)),
                const SizedBox(height: 24),
                const Text('Deskripsi Menu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kInk)),
                const SizedBox(height: 8),
                Text(item.desc, style: const TextStyle(fontSize: 15, color: kGrey, height: 1.6)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kField,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.restaurant, color: kOrange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Porsi: 1 orang',
                                style: TextStyle(color: kInk, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.timer, color: kOrange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Estimasi penyajian: 15-20 menit',
                                style: TextStyle(color: kInk, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: kOrange, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: kOrange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('Tunjukkan menu ini ke pelayan atau catat untuk dipesan.',
                            style: TextStyle(color: kInk, fontSize: 13, height: 1.4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OrangeButton('Kembali ke Menu', () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
