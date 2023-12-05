import 'package:flutter/material.dart';

class Favoritku extends StatelessWidget {
  const Favoritku({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritku',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite_outline_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            Text(
              'Belum Ada Favorit',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Text(
              'Tambahkan favorite dengan mengklik ikon favorit di masing-masing event',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
