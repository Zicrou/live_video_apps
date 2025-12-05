// /lib/main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const LiveApp());
}

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
