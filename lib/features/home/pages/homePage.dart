import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF35003B),
              Color(0xFF1D0021),
              Color(0xFF0D000F),
              Color(0xFF000000),
            ],
          ),
        ),
      ),
    );
  }
}
