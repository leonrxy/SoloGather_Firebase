import 'package:flutter/material.dart';

class Profilku extends StatelessWidget {
  const Profilku({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profilku',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 85, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 85, 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 140),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/header.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            buildBiodataRow(Icons.person, 'Nama Lengkap', 'Riski Adi'),
            buildDivider(),
            buildBiodataRow(Icons.email, 'Email', 'admin@sg.com'),
            buildDivider(),
            buildBiodataRow(Icons.location_on, 'Alamat', 'Surakarta'),
            buildDivider(),
            buildBiodataRow(Icons.phone, 'Phone', '08988888888'),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget buildBiodataRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 44, 26, 26),
            size: 24,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 44, 41, 41),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 44, 41, 41),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 20,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Profilku(),
  ));
}
