import 'package:flutter/material.dart';

class PesanTiketSukses extends StatelessWidget {
  const PesanTiketSukses({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/images/tickets.png',
                    width: 200,
                  ),
                ),
                Text('Yey, kamu berhasil memesan tiket!'),
                Text('Tiket kamu sudah dikirim ke email kamu'),
              ],
            ),
          )),
    );
  }
}
