import 'package:flutter/material.dart';

class KritikSaran extends StatelessWidget {
  const KritikSaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kritik & Saran',
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
        child: Text('KRITIK & SARAN'),
      ),
    );
  }
}
