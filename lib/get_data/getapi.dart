import 'package:http/http.dart' as http;
import 'dart:convert';

class Events {
  final String id;
  final String nama;
  final String foto;
  final String biaya;
  final String tanggal;
  final String jam_mulai;
  final String jam_selesai;
  final String tempat;
  final String deskripsi;
  final String gmaps;

  const Events({
    required this.id,
    required this.nama,
    required this.foto,
    required this.biaya,
    required this.tanggal,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.tempat,
    required this.deskripsi,
    required this.gmaps,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      id: json['id'],
      nama: json['nama'],
      foto: json['foto'],
      biaya: json['biaya'],
      tanggal: json['tanggal'],
      jam_mulai: json['jam_mulai'],
      jam_selesai: json['jam_selesai'],
      tempat: json['tempat'],
      deskripsi: json['deskripsi'],
      gmaps: json['gmaps'],
    );
  }
}

class Repo {
  Future<List<Events>> getData(String category) async {
    try {
      final response = await http.get(Uri.parse(
          'https://leonrxy.my.id/sologather/api.php?kategori=$category'));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Events> event = it.map((e) => Events.fromJson(e)).toList();
        return event;
      } else {
        throw Exception('Gagal memuat konten');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
