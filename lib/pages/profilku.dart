import 'package:flutter/material.dart';
import 'editprofilku.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profilku extends StatefulWidget {
  const Profilku({Key? key});

  @override
  State<Profilku> createState() => _ProfilkuState();
}

class _ProfilkuState extends State<Profilku> {
  String nama = '';
  String email = '';
  String alamat = '';
  String no_hp = '';
  String userUid = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userUid = prefs.getString('userUid') ?? '';
      print('UID : ' + userUid);

      // Inisialisasi Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Mendapatkan referensi dokumen pengguna berdasarkan ID pengguna (ganti dengan ID pengguna yang sesuai)
      DocumentReference userDocument =
          firestore.collection('users').doc(userUid);

      // Mendapatkan data dari Firestore
      DocumentSnapshot documentSnapshot = await userDocument.get();

      // Mengupdate state dengan data yang diambil dari Firestore
      setState(() {
        // Check if the fields exist before accessing them
        nama =
            documentSnapshot['name'] != null ? documentSnapshot['name'] : '-';
        email =
            documentSnapshot['email'] != null ? documentSnapshot['email'] : '-';
        documentSnapshot['alamat'] != null
            ? alamat = documentSnapshot['alamat']
            : '-';
        documentSnapshot['no_hp'] != null
            ? no_hp = documentSnapshot['no_hp']
            : '-';
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profilku',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
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
                ],
              ),
            ),
            SizedBox(height: 30),
            buildBiodataRow(Icons.person, 'Nama Lengkap', nama),
            buildDivider(),
            buildBiodataRow(Icons.email, 'Email', email),
            buildDivider(),
            buildBiodataRow(Icons.location_on, 'Alamat', alamat),
            buildDivider(),
            buildBiodataRow(Icons.phone, 'Phone', no_hp),
            buildDivider(),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilku(nama: nama, email: email, alamat: alamat, no_hp: no_hp),
                    ),
                  );
                },
                child: Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
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
