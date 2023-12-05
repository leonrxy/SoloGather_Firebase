import 'package:flutter/material.dart';

class Pengaturan extends StatelessWidget {
  const Pengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Text('PENGATURAN'),
      ),
    );
  }
}
