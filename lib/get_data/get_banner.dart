import 'package:cloud_firestore/cloud_firestore.dart';

class AppBanner {
  final String id;
  final String foto;

  const AppBanner({
    required this.id,
    required this.foto,
  });

  factory AppBanner.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Data is null in document ${doc.id}');
    }
    return AppBanner(
      id: doc.id,
      foto: data['foto'],
    );
  }
}

class RepoBanner {
  Future<List<AppBanner>> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('banner').get();

      print('Number of documents: ${querySnapshot.docs.length}');

      List<AppBanner> banner = querySnapshot.docs.map((doc) {
        return AppBanner.fromFirestore(doc);
      }).toList();
      return banner;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
