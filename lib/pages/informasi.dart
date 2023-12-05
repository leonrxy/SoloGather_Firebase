import 'package:flutter/material.dart';

class Informasi extends StatelessWidget {
  const Informasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi',
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
        child: Text('INFORMASI'),
      ),
    );
  }
}
