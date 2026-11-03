import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_widgets.dart';
import 'main_shell.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: kInk,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
                image: DecorationImage(
                  image: NetworkImage(img('1504674900247-0877df9cc836')),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: const Text('MADHANG\nDINE-IN',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat datang!',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kInk)),
                  const SizedBox(height: 4),
                  const Text('Masukkan nomor meja Anda untuk mulai melihat menu di tempat.',
                      style: TextStyle(color: kGrey)),
                  const SizedBox(height: 24),
                  const AppField('Nomor Meja (Contoh: Meja 05)', Icons.table_restaurant_outlined),
                  const SizedBox(height: 14),
                  const AppField('Nama Pelanggan', Icons.person_outline),
                  const SizedBox(height: 24),
                  OrangeButton('Mulai Lihat Menu', () => goRoot(context, const MainShell())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
