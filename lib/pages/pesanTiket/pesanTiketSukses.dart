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
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text('Yey, kamu berhasil memesan tiket!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text('Tiket kamu sudah dikirim ke email kamu',
                    style: TextStyle(fontSize: 16)),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('Kembali ke Home',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
