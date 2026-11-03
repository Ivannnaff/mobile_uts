import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_widgets.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  RoundIcon(Icons.arrow_back, () => Navigator.pop(context)),
                  const SizedBox(width: 14),
                  const Text('Lokasi Restoran',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kField,
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: NetworkImage(img('1504674900247-0877df9cc836')),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 80, color: kOrange),
                      SizedBox(height: 16),
                      Text('Restoran Madhang',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Text('Jl. Melati No. 123',
                          style: TextStyle(fontSize: 16, color: Colors.white70)),
                      Text('Kota Surabaya', style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kField,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.directions_car, color: kOrange),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                              'Parkir luas tersedia untuk kendaraan roda 2 dan roda 4',
                              style: TextStyle(color: kInk, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OrangeButton('Kembali ke Menu', () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
