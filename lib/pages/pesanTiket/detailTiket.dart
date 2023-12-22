import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sologather/get_data/get_events_firebase.dart';
import 'package:sologather/pages/pesanTiket/pesanTiketSukses.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailTiket extends StatefulWidget {
  const DetailTiket(
      {super.key,
      required this.event,
      required this.date,
      required this.jmlTiket});

  final Events event;
  final int jmlTiket;
  final String date;

  @override
  State<DetailTiket> createState() => _DetailTiketState();
}

class _DetailTiketState extends State<DetailTiket> {
  List<Events> listEvent = [];
  bool isLoading = true;
  Repo repo = Repo();
  late SharedPreferences prefs;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String email = '';
  String name = '';
  String harga = '';
  String foto = '';
  String jmlTiket = '';
  String tanggal = '';
  String jam_mulai = '';
  String jam_selesai = '';
  String tempat = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    init();
    getProfil();
  }

  beliTiket() async {
    try {
      harga = widget.event.biaya * widget.jmlTiket.toInt();
      jmlTiket = widget.jmlTiket.toString();
      tanggal = widget.date;
      jam_mulai = widget.event.jam_mulai;
      jam_selesai = widget.event.jam_selesai;
      tempat = widget.event.tempat;
      foto = widget.event.foto;
      await FirebaseFirestore.instance
          .collection('tiket')
          .doc(_auth.currentUser!.uid)
          .set({
        'email': email,
        'nama': name,
        'harga': harga,
        'foto': foto,
        'jmlTiket': jmlTiket,
        'tanggal': tanggal,
        'jam_mulai': jam_mulai,
        'jam_selesai': jam_selesai,
        'tempat': tempat,
      });

      // Registration successful
      setState(() {
        // Update the UI as needed
      });

      // Navigate to the desired screen (e.g., home screen)
      Navigator.pushReplacementNamed(context, '/pesanTiketSukses');
    } on FirebaseAuthException catch (e) {
      // Registration failed
      setState(() {
        print(e.code);
      });
    }
  }

  Future<void> init() async {
    await getData();
  }

  Future<void> getData() async {
    try {
      List<Events> event = await repo.getData();

      if (mounted) {
        setState(() {
          listEvent = event;
          if (listEvent.length == 0) {
            isLoading = true;
          } else {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      setState(() {
        isLoading = true;
      });
    }
  }

  String formatTime(String time) {
    // Parse the time string to DateTime
    DateTime parsedTime = DateTime.parse("2023-01-01 " + time);

    // Format the DateTime to the desired time format
    String formattedTime = DateFormat.Hm().format(parsedTime);

    return formattedTime;
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###");

    return formatter.format(amount);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('dd MMM yyyy', 'id').format(args.value.startDate)} -'
            ' ${DateFormat('dd MMM yyyy', 'id').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        // Format the date using intl package
        _selectedDate = DateFormat('dd MMM yyyy', 'id').format(args.value);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Future<void> getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('userEmail') ?? '';
    print('Email' + email);
    name = prefs.getString('userName') ?? '';
    print('Name' + name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Selesaikan Pesananmu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: <Widget>[
            Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                height: 350,
                child: ListView(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.event.foto,
                                fit: BoxFit.fill,
                                width: 60,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Text(
                                widget.event.nama,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors
                          .grey, // Sesuaikan warna garis pembatas sesuai kebutuhan
                      height:
                          20, // Sesuaikan ketinggian garis pembatas sesuai kebutuhan
                      thickness:
                          1, // Sesuaikan ketebalan garis pembatas sesuai kebutuhan
                    ),
                    Container(
                      padding: EdgeInsets.only(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumlah Tiket',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.jmlTiket.toString() + " Tiket",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(
                      color: Colors
                          .grey, // Sesuaikan warna garis pembatas sesuai kebutuhan
                      height:
                          20, // Sesuaikan ketinggian garis pembatas sesuai kebutuhan
                      thickness:
                          1, // Sesuaikan ketebalan garis pembatas sesuai kebutuhan
                    ),
                    Container(
                      padding: EdgeInsets.only(),
                      child: Text(
                        'Tanggal Dipilih',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(
                      color: Colors
                          .grey, // Sesuaikan warna garis pembatas sesuai kebutuhan
                      height:
                          20, // Sesuaikan ketinggian garis pembatas sesuai kebutuhan
                      thickness:
                          1, // Sesuaikan ketebalan garis pembatas sesuai kebutuhan
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Icon(
                                Icons.flash_on,
                                size: 30,
                                color: Colors
                                    .grey, // Sesuaikan warna ikon sesuai kebutuhan
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Konfirmasi instan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Tidak perlu reservasi',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Icon(
                                Icons.money_off,
                                size: 30,
                                color: Colors
                                    .grey, // Sesuaikan warna ikon sesuai kebutuhan
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tidak bisa refund',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Icon(
                                Icons.hourglass_bottom,
                                size: 30,
                                color: Colors
                                    .grey, // Sesuaikan warna ikon sesuai kebutuhan
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Berlaku di tanggal dipilih',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Detail Pemesanan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama : ' + name,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Email : ' + email,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  //padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'IDR ' +
                              formatCurrency((int.parse(widget.event.biaya)) *
                                  widget.jmlTiket.toInt()),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PesanTiketSukses(),
                              ),
                            );
                          },
                          child: Text(
                            'Lanjutkan Pembayaran',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
