import 'package:flutter/material.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  bool terimaNotifikasi = true;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Terima Notifikasi'),
              trailing: Switch(
                value: terimaNotifikasi,
                onChanged: (value) {
                  setState(() {
                    terimaNotifikasi = value;
                  });
                  if (value) {
                    print('Notifikasi diaktifkan');
                  } else {
                    print('Notifikasi dimatikan');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Pengaturan(),
    ),
  ));
}
