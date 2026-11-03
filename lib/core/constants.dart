import 'package:flutter/material.dart';

const Color kOrange = Color(0xFFFF5A2D);
const Color kInk = Color(0xFF1E1E22);
const Color kGrey = Color(0xFF8A8A93);
const Color kField = Color(0xFFF4F4F6);

String img(String id) => 'https://images.unsplash.com/photo-$id?fm=webp&fit=crop&w=700&q=70';

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

void goRoot(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}
