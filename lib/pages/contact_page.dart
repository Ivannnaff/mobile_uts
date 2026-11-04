import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/custom_widgets.dart';
import 'location_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
                  const Text('Hubungi Kami',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kInk)),
                ],
              ),
              const SizedBox(height: 30),
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
                        Icon(Icons.phone, color: kOrange),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Telepon', style: TextStyle(fontSize: 12, color: kGrey)),
                            SizedBox(height: 2),
                            Text('0812-3456-7890',
                                style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.email, color: kOrange),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: TextStyle(fontSize: 12, color: kGrey)),
                            SizedBox(height: 2),
                            Text('info@madhang.com',
                                style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: kOrange),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alamat', style: TextStyle(fontSize: 12, color: kGrey)),
                              SizedBox(height: 2),
                              Text('Jl. Melati No. 123, Kota Surabaya',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Jam Operasional',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kInk)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: kField, width: 2),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Senin - Jumat', style: TextStyle(color: kInk)),
                        Text('08:00 - 22:00',
                            style: TextStyle(fontWeight: FontWeight.bold, color: kOrange)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sabtu - Minggu', style: TextStyle(color: kInk)),
                        Text('09:00 - 23:00',
                            style: TextStyle(fontWeight: FontWeight.bold, color: kOrange)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              OrangeButton('Lihat Lokasi di Maps', () => go(context, const LocationPage())),
            ],
          ),
        ),
      ),
    );
  }
}
