import 'package:flutter/material.dart';
import 'package:sologather/get_data/get_tiket.dart';
import 'package:sologather/pages/pageDetailTiket.dart';
import 'package:sologather/widgets/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TiketSaya extends StatefulWidget {
  const TiketSaya({Key? key}) : super(key: key);

  @override
  State<TiketSaya> createState() => _TiketSayaState();
}

class _TiketSayaState extends State<TiketSaya> {
  final db = FirebaseFirestore.instance;
  List<DataTiket> listTiket = [];
  bool isLoading = true;
  RepoTiket repo = RepoTiket();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getEmail();
    await getData();
  }

  Future<void> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('userEmail') ?? '';
      print('Email : ' + userEmail);
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  Future<void> getData() async {
    try {
      String userEmail =
          'email_pengguna@contoh.com'; // Ganti dengan email pengguna sebenarnya
      List<DataTiket> tiket = await repo.getData(userEmail);

      if (mounted) {
        setState(() {
          listTiket = tiket;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred while fetching booking data: $e');
      setState(() {
        isLoading = true;
      });
    }
  }

  String formatTime(String time) {
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);
    String formattedTime = DateFormat.Hm().format(parsedTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pemesanan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? AppShimmer(width: 500, height: 200)
          : Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listTiket.length,
                itemBuilder: (context, index) {
                  DataTiket data = listTiket[index];
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PageDetailTiket(tiket: data),
                      //   ),
                      // );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          data.nama,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Harga: ${data.harga}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Jumlah Tiket: ${data.jmlTiket}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Tanggal: ${data.tanggal}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Jam: ${formatTime(data.jam_mulai)} - ${formatTime(data.jam_selesai)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Tempat: ${data.tempat}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
