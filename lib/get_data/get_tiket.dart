import 'package:cloud_firestore/cloud_firestore.dart';

class DataTiket {
  final String id;
  final String email;
  final String nama;
  final String harga;
  final String foto;
  final String jmlTiket;
  final String tanggal;
  final String jam_mulai;
  final String jam_selesai;
  final String tempat;

  const DataTiket({
    required this.id,
    required this.email,
    required this.nama,
    required this.harga,
    required this.foto,
    required this.jmlTiket,
    required this.tanggal,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.tempat,
  });

  factory DataTiket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Data is null in document ${doc.id}');
    }
    return DataTiket(
      id: doc.id,
      nama: data['nama'],
      email: data['email'],
      harga: data['harga'],
      foto: data['foto'],
      jmlTiket: data['jmlTiket'],
      tanggal: data['tanggal'],
      jam_mulai: data['jam_mulai'],
      jam_selesai: data['jam_selesai'],
      tempat: data['tempat'],
    );
  }
}

class RepoTiket {
  Future<List<DataTiket>> getData(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tiket')
          .where('email', isEqualTo: email)
          .get();

      print('Number of documents: ${querySnapshot.docs.length}');

      List<DataTiket> tiket = querySnapshot.docs.map((doc) {
        return DataTiket.fromFirestore(doc);
      }).toList();
      return tiket;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
