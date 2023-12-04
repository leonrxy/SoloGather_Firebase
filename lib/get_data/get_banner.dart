import 'package:http/http.dart' as http;
import 'dart:convert';

class AppBanner {
  final String id;
  final String nama;
  final String foto;

  const AppBanner({
    required this.id,
    required this.nama,
    required this.foto,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['id'],
      nama: json['nama'],
      foto: json['foto'],
    );
  }
}

class RepoBanner {
  Future<List<AppBanner>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://leonrxy.my.id/sologather/api.php?kategori=banner'));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<AppBanner> event = it.map((e) => AppBanner.fromJson(e)).toList();
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
