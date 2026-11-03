import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
                  const SizedBox(width: 14),
                  const Text('Bantuan & Panduan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration:
                    BoxDecoration(color: kField, borderRadius: BorderRadius.circular(18)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cara Memesan di Meja:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kInk)),
                    SizedBox(height: 10),
                    Text('1. Pilih kategori menu (Makanan, Snack, Minuman).',
                        style: TextStyle(color: kGrey, height: 1.4)),
                    Text('2. Catat atau tunjukkan menu pilihan ke pelayan.',
                        style: TextStyle(color: kGrey, height: 1.4)),
                    Text('3. Pembayaran dilakukan di kasir setelah selesai.',
                        style: TextStyle(color: kGrey, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: kField, width: 2),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Metode Pembayaran:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kInk)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('Tunai (Cash)', style: TextStyle(color: kInk)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('Debit Card (BCA, Mandiri, BRI)', style: TextStyle(color: kInk)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('E-Wallet (GoPay, OVO, Dana)', style: TextStyle(color: kInk)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              OrangeButton('Kembali', () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
