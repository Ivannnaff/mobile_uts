import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_widgets.dart';
import 'contact_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                  const Text('Tentang Aplikasi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                  child: const Icon(Icons.restaurant, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('MADHANG',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: kInk,
                        letterSpacing: 3)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Aplikasi Menu Dine-In', style: TextStyle(fontSize: 14, color: kGrey)),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kField,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fitur Aplikasi:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kInk)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('Lihat menu makanan dan minuman', style: TextStyle(color: kInk)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('Filter kategori menu', style: TextStyle(color: kInk)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: kOrange, size: 20),
                        SizedBox(width: 10),
                        Text('Menu favorit pelanggan', style: TextStyle(color: kInk)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => go(context, const ContactPage()),
                  child: const Text('Hubungi Kami',
                      style: TextStyle(color: kOrange, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
