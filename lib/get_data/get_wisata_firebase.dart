import 'package:cloud_firestore/cloud_firestore.dart';

class DataWisata {
  final String id;
  final String nama;
  final String telp;
  final String foto;
  final String biaya;
  final String jam_buka;
  final String jam_tutup;
  final String tempat;
  final String deskripsi;
  final String gmaps;

  DataWisata({
    required this.id,
    required this.nama,
    required this.telp,
    required this.foto,
    required this.biaya,
    required this.jam_buka,
    required this.jam_tutup,
    required this.tempat,
    required this.deskripsi,
    required this.gmaps,
  });

  factory DataWisata.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Data is null in document ${doc.id}');
    }

    return DataWisata(
      id: doc.id,
      nama: data['nama'] ?? '',
      telp: data['telp'] ?? '',
      foto: data['foto'] ?? '',
      biaya: data['biaya'] ?? '',
      jam_buka: data['jam_buka'] ?? '',
      jam_tutup: data['jam_tutup'] ?? '',
      tempat: data['tempat'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      gmaps: data['gmaps'] ?? '',
    );
  }
}

class RepoWisata {
  Future<List<DataWisata>> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('wisata').get();

      print('Number of documents: ${querySnapshot.docs.length}');

      List<DataWisata> wisata = querySnapshot.docs.map((doc) {
        return DataWisata.fromFirestore(doc);
      }).toList();
      print(wisata.first.nama);
      return wisata;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
