import 'package:http/http.dart' as http;
import 'dart:convert';

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

  factory DataWisata.fromJson(Map<String, dynamic> json) {
    final wisata = DataWisata(
      id: json['id'],
      nama: json['nama'],
      telp: json['telp'],
      foto: json['foto'],
      biaya: json['biaya'],
      jam_buka: json['jam_buka'],
      jam_tutup: json['jam_tutup'],
      tempat: json['tempat'],
      deskripsi: json['deskripsi'],
      gmaps: json['gmaps'],
    );

    return wisata;
  }
}

class Repo {
  Future<List<DataWisata>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://leonrxy.my.id/sologather/api.php?kategori=wisata'));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<DataWisata> wisata = it.map((e) => DataWisata.fromJson(e)).toList();
        return wisata;
      } else {
        throw Exception('Gagal memuat konten');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
