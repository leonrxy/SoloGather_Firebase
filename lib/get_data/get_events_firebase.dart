import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Events({
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

  factory Events.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Data is null in document ${doc.id}');
    }
    final event = Events(
      id: doc.id,
      nama: data['nama'],
      foto: data['foto'],
      biaya: data['biaya'],
      tanggal: data['tanggal'],
      jam_mulai: data['jam_mulai'],
      jam_selesai: data['jam_selesai'],
      tempat: data['tempat'],
      deskripsi: data['deskripsi'],
      gmaps: data['gmaps'],
    );

    return event;
  }
}

class Repo {
  Future<List<Events>> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      print('Number of documents: ${querySnapshot.docs.length}');

      List<Events> events = querySnapshot.docs.map((doc) {
        return Events.fromFirestore(doc);
      }).toList();
      print(events.first.nama);
      return events;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
