import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'pages/login_page.dart';

void main() => runApp(const MadhangApp());

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
      // Membatasi lebar agar tetap seperti tampilan HP (tidak melebar seperti web)
      builder: (context, child) => Container(
        color: const Color(0xFFE9EBF0),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
