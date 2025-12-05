// /lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'host_page.dart';
import 'viewer_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TikTok Live Clone")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Start Live (Host)"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HostPage()),
              ),
            ),
            ElevatedButton(
              child: const Text("Watch Live (Viewers)"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewerPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
